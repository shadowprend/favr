import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:favr/models/chat_message.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../supplemental/chat_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
part 'chat_events.dart';
part 'chat_state.dart';


enum MessageType {
  Sender,
  Receiver,
}

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(DataStateLoading());

  List<StreamSubscription> subscriptions = [];
  List<List<ChatMessage>> posts = [];
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
  Stream<ChatState> mapEventToState(ChatEvent event) async* {
    if (event is ChatEventStart) {
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
          ChatRepository(event.key).getPosts().listen((event) {
            handleStreamEvent(0, event);
          })
      );
    }

    if (event is ChatEventLoad) {
      // Flatten the posts list
      final elements = posts.expand((i) => i).toList();
      if (elements.isEmpty) {
        yield DataStateEmpty();
      } else {
        yield DataStateLoadSuccess(elements, hasMoreData);
      }
    }

    if (event is ChatEventFetchMore) {
      if (lastDoc == null) {
        throw Exception("Last doc is not set");
      }
      final index = posts.length;
      subscriptions.add(
          ChatRepository(event.key).getPostsPage(lastDoc).listen((event) {
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

  handleStreamEvent(int index, QuerySnapshot snap) {
    // We request 15 docs at a time
    if (snap.docs.length < 15) {
      hasMoreData = false;
    }

    // If the snapshot is empty, there's nothing for us to do

    if (snap.docs.isEmpty) posts.add([]);
    if (index == posts.length) {
      // Set the last document we pulled to use as a cursor
      lastDoc = snap.docs[snap.docs.length - 1];
    }
    // Turn the QuerySnapshot into a List of posts
    List<ChatMessage> newList = [];
    snap.docs.reversed.forEach((doc) {
      // This is a good spot to filter your data if you're not able
      // to compose the query you want.
      var messagetype = MessageType.Receiver;
      final messageText = doc.data()['message'];
      final messageSender = doc.data()['user'];

      if (messageSender == loggedInUser.uid) {
        messagetype = MessageType.Sender;
      }
      var data =
      ChatMessage(message: messageText, type: messagetype);
      newList.add(data);
    });
    // Update the posts list
    if (posts.length <= index) {
      posts.add(newList);
    } else {
      posts[index].clear();
      posts[index] = newList;
    }
    add(ChatEventLoad(posts));
  }
}