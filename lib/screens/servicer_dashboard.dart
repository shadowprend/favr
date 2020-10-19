import 'package:favr/widgets/chat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:favr/models/search.dart';
import 'package:favr/widgets/maindrawer.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:favr/models/chat_users.dart';

class ServicerDashboard extends StatefulWidget {
  static String id = 'servicedashboard';
  @override
  _ServicerDashboardState createState() => _ServicerDashboardState();
}

class _ServicerDashboardState extends State<ServicerDashboard> {
  final _firestore = FirebaseFirestore.instance;
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
  void initState() {
    super.initState();

    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PhoneBook',
          style: TextStyle(color: Colors.black45),
        ),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.black45,
            ),
            onPressed: () async {
              showSearch(context: context, delegate: DataSearch());
            },
          ),
          IconButton(
            icon: Icon(
              Icons.person_pin,
              color: Colors.black45,
            ),
            onPressed: () {},
          ),
        ],
        backgroundColor: Colors.white, // Don't show the leading button
      ),
      drawer: MainDrawer(),
      body: Stack(
        children: [
          StreamBuilder(
              stream: _firestore
                  .collection('messageconnection')
                  .where('uid', isEqualTo: loggedInUser.uid)
                  .snapshots(),
              // ignore: missing_return
              builder: (context, snapshot) {
                List<ChatUsers> chatUsers = [];
                if (snapshot.hasData) {
                  final _contacts = snapshot.data.docs;
                  for (var contact in _contacts) {
                    for (var userinfo in contact.data()['users']) {
                      chatUsers.add(
                        ChatUsers(
                            receiver: userinfo['id'],
                            text: userinfo['name'],
                            secondaryText: userinfo['recentmessage'],
                            image: "images/userImage1.jpeg",
                            time: "Now"),
                      );
                    }
                  }
                }
                return ListView.builder(
                  itemCount: chatUsers.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ChatUsersList(
                        receiver: chatUsers[index].receiver,
                        text: chatUsers[index].text,
                        secondaryText: chatUsers[index].secondaryText,
                        image: chatUsers[index].image,
                        time: chatUsers[index].time,
                        isMessageRead: false);
                  },
                );
              }),
        ],
      ),
    );
  }
}
