import 'package:favr/chatblocs/chat_block.dart';
import 'package:favr/utilities/constant.dart';
import 'package:favr/widgets/chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

enum MessageType2 {
  Sender,
  Receiver,
}

class ChatDetailPage extends StatefulWidget {
  static String id = 'chatdetailpage';
  final String name;
  final String details;
  final String receiver;
  final String conversationID;
  ChatDetailPage({this.name, this.details, this.receiver, this.conversationID});

  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final messageTextController = TextEditingController();
  final CollectionReference _postCollection = FirebaseFirestore.instance.collection('messages');
  final _firestore = FirebaseFirestore.instance;
  String _messageText;
  ChatBloc _dataBloc = ChatBloc();
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
    _dataBloc.add(ChatEventStart(widget.conversationID));
    getCurrentUser();
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
          BlocBuilder<ChatBloc, ChatState>(
              cubit: _dataBloc,
              // ignore: missing_return
              builder: (BuildContext context, ChatState state) {
                if (state is DataStateLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is DataStateEmpty) {
                  return Center(
                    child: Text('No Posts', style: Theme.of(context).textTheme.bodyText1,),
                  );
                } else if (state is DataStateLoadSuccess) {
                  return ListView.builder(
                    padding: EdgeInsets.fromLTRB(15, 10, 15, 120),
                    reverse: true,
                    itemCount: state.hasMoreData ? state.posts.length + 1 : state.posts.length,
                    itemBuilder: (context, i) {
                      if (i >= state.posts.length) {
                        _dataBloc.add(ChatEventFetchMore(widget.conversationID));
                        return Container(
                          margin: EdgeInsets.only(top: 15),
                          height: 30,
                          width: 30,
                          child: Center(child: Text('No more Post')),
                        );
                      }
                      return ChatBubble(
                        chatMessage: state.posts[i],
                      );
                    },
                  );
                }
              }
          ),
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
                onPressed: () async {
                  messageTextController.clear();
                  try{
                    var chatlength = await _firestore.collection('messages').doc(widget.conversationID).collection('conversation').orderBy('time', descending: false).get();
                    var getLastDoc = await _firestore.collection('messages').doc(widget.conversationID).collection('conversation').limit(1).orderBy('time', descending: false).get();
                    if(chatlength.docs.length >= chatLimit){
                      for(var s in getLastDoc.docs){
                        var docID = s.id;
                        print(docID);
                        _firestore.collection('messages').doc(widget.conversationID).collection('conversation').doc(docID).delete();
                      }
                    }
                    if(_messageText.isNotEmpty){
                      _firestore.collection('messages').doc(widget.conversationID).collection('conversation').add({
                        'user': loggedInUser.uid,
                        'hasread': false,
                        'message': _messageText,
                        'time': FieldValue.serverTimestamp(),
                      });

                      print(chatlength.docs.length);
                    }
                  }catch(e){
                    // TODO: Add SnackBar here.
                  }
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
