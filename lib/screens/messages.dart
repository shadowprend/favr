import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:favr/models/chat_users.dart';
import 'package:favr/widgets/chat.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class Messages extends StatefulWidget {
  static String id = 'messages';

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = auth.FirebaseAuth.instance;
  List<ChatUsers> _oldFilters = const [];
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

  Future<dynamic> getRecentMessage(id) async{
    final conversation = _firestore
        .collection('messagetest').doc(id)
        .collection('conversation')
        .limit(1)
        .orderBy('time', descending: true)
        .get();

    final messageItem = conversation.then((key){
      for(var v in key.docs){
        return [v.data()['message'], v.data()['time']];
      }
    });
    return messageItem;
  }

  Future<dynamic> getUserName(id) async{

    final conversation = _firestore
        .collection('userdata')
        .where('uid', isEqualTo: id)
        .get();

    final userName = conversation.then((key){
      for(var v in key.docs){
        return '${v.data()['firstname']} ${v.data()['lastname']}';
      }
    });
    return userName;
  }

  Future<List<ChatUsers>> _MessageList() async{
    var uid = loggedInUser.uid;
    final messageHistory = _firestore
        .collection('messagetest')
        .where("participants", arrayContains: uid)
        .get();
    final history = messageHistory.then((value) async{
      List<ChatUsers> contactList = [];
      for(var v in value.docs){
        var id = v.data()['participants'];
        id.remove(uid);
        final recentMessage = await getRecentMessage(v.id); //Retrieve Recent Message
        final username = await getUserName(id[0]); //Retrieve User
        contactList.add(ChatUsers(
            receiver: id[0],
            text: username,
            secondaryText: recentMessage[0],
            image: "images/userImage1.jpeg",
            time: 'Now'),);
          // TODO: Filter Time to now or tomorrow depends on the Time tamps recentMessage[1].toString()
      }
      return contactList;
    });
    return history;
  }



  @override
  void initState() {
    super.initState();
    getCurrentUser();

    // print(loggedInUser.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Text("Messages"),
      ),
      body: Stack(
        children: [
      FutureBuilder<List<ChatUsers>>(
      future: _MessageList(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _oldFilters = snapshot.data;
          return ListView.builder(
            itemCount: _oldFilters.length,
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 10, bottom: 10),
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return ChatUsersList(
                  receiver: _oldFilters[index].receiver,
                  text: _oldFilters[index].text,
                  secondaryText: _oldFilters[index].secondaryText,
                  image: _oldFilters[index].image,
                  time: _oldFilters[index].time,
                  isMessageRead: false);
            },
          );

        } else {
          return Container(
              child: Center(
                child: Text('No recent searches'),
              ));
        }
      },
    )

        ],
      ),
    );
  }
}
