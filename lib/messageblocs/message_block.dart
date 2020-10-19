import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:favr/models/messages.dart';
import 'package:favr/supplemental/message_respository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
part 'message_events.dart';
part 'message_state.dart';

enum MessageType {
  Sender,
  Receiver,
}

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  MessageBloc() : super(MessageStateLoading());

  List<StreamSubscription> subscriptions = [];
  List<List<Messages>> posts = [];
  bool hasMoreData = true;
  DocumentSnapshot lastDoc;
  final _auth = auth.FirebaseAuth.instance;

  auth.User loggedInUser;

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Stream<MessageState> mapEventToState(MessageEvent event) async* {
    if (event is MessageEventStart) {
      // Clean up our variables
      hasMoreData = true;
      lastDoc = null;
      subscriptions.forEach((sub) {
        sub.cancel();
      });

      getCurrentUser();
      posts.clear();
      subscriptions.clear();
      subscriptions.add(
          MessageRepository(loggedInUser.uid).getPosts().listen((event) {
            handleStreamEvent(0, event);
          })
      );
    }

    if (event is MessageEventLoad) {
      // Flatten the posts list
      final elements = posts.expand((i) => i).toList();

      if (elements.isEmpty) {
        yield MessageStateEmpty();
      } else {
        yield MessageStateLoadSuccess(elements, hasMoreData);
      }
    }

    if (event is MessageEventFetchMore) {
      if (lastDoc == null) {
        throw Exception("Last doc is not set");
      }
      final index = posts.length;
      subscriptions.add(
          MessageRepository(loggedInUser.uid).getPostsPage(lastDoc).listen((event) {
            handleStreamEvent(index, event);
          })
      );
    }
  }

  @override
  onChange(change) {
    print(change);
    super.onChange(change);
  }

  @override
  Future<void> close() async {
    subscriptions.forEach((s) => s.cancel());
    super.close();
  }

  handleStreamEvent(int index, QuerySnapshot snap) async{
    // We request 15 docs at a time
    if (snap.docs.length < 15) {
      hasMoreData = false;
    }

    // If the snapshot is empty, there's nothing for us to do
    if (snap.docs.isEmpty) return;

    if (index == posts.length) {
      // Set the last document we pulled to use as a cursor
      lastDoc = snap.docs[snap.docs.length - 1];
    }
    // Turn the QuerySnapshot into a List of posts
    List<Messages> newList = [];

    snap.docs.reversed.forEach((doc){


      var id = doc.id;
      var participantsId = doc.data()['participants'];
      var recentMessage = doc.data()['recentmessage'];
      var recentTime = doc.data()['recenttime'];


      // print(recentTime);
      // id.remove(loggedInUser.uid);

      var data = Messages(participantsId, id,recentMessage, 'Time Here');

      newList.add(data);
    });

    // Update the posts list
    if (posts.length <= index) {
      posts.add(newList);
    } else {
      posts[index].clear();
      posts[index] = newList;
    }
    add(MessageEventLoad(posts));
  }
}