import 'package:favr/models/chat_message.dart';
import 'package:favr/utilities/constant.dart';
import 'package:favr/widgets/chat_bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

enum MessageType {
  Sender,
  Receiver,
}

class ChatDetailPage extends StatefulWidget {
  static String id = 'chatdetailpage';
  final String name;
  final String details;
  final String receiver;
  ChatDetailPage({this.name, this.details, this.receiver});

  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final _firestore = FirebaseFirestore.instance;
  final messageTextController = TextEditingController();
  final _auth = auth.FirebaseAuth.instance;
  var now = new DateTime.now();
  String _messageText;
  List<ChatMessage> chatMessage = [];

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
    // print(conversation());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 2,
                ),
                CircleAvatar(
                  child: Text(
                    getInitials(widget.name),
                  ),
                  maxRadius: 20,
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        widget.name,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        '+63' + widget.details,
                        style: TextStyle(color: Colors.green, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.more_vert,
                  color: Colors.grey.shade700,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          StreamBuilder(
              stream: _firestore
                  .collection('messagetest')
                  .doc('176CNuky6begL9udum8A')
                  .collection('conversation')
                  .orderBy('time', descending: false)
                  .snapshots(),
              // ignore: missing_return
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final _messages = snapshot.data.docs.reversed;

                  List<ChatMessage> chatMessage = [];
                  for (var message in _messages) {
                    var messagetype = MessageType.Receiver;
                    final messageText = message.data()['message'];
                    final messageSender = message.data()['user'];

                    if (messageSender == loggedInUser.uid) {
                      messagetype = MessageType.Sender;
                    }
                    var data =
                        ChatMessage(message: messageText, type: messagetype);
                    chatMessage.add(data);
                  }

                  return Container(
                    margin: EdgeInsets.only(bottom: 100.0),
                    child: ListView.builder(
                      reverse: true,
                      itemCount: chatMessage.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return ChatBubble(
                          chatMessage: chatMessage[index],
                        );
                      },
                    ),
                  );
                }

                return Container();
              }),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 16, bottom: 10),
              height: 80,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        _messageText = value;
                      },
                      decoration: InputDecoration(
                          hintText: "Type message...",
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                          border: InputBorder.none),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              padding: EdgeInsets.only(right: 30, bottom: 50),
              child: FloatingActionButton(
                onPressed: () {
                  messageTextController.clear();
                  _firestore
                      .collection('messagetest')
                      .doc('176CNuky6begL9udum8A')
                      .collection('conversation')
                      .add({
                    'user': loggedInUser.uid,
                    'hasread': false,
                    'message': _messageText,
                    'time': FieldValue.serverTimestamp(),
                  });
                },
                child: Icon(
                  Icons.send,
                  color: Colors.white,
                ),
                backgroundColor: Colors.blueAccent,
                elevation: 0,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
