import 'package:favr/chatblocs/chat_block.dart';
import 'package:favr/widgets/chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LazyListScreen extends StatefulWidget {
  static String id = 'lazy';
  final String conversationID;

  LazyListScreen({this.conversationID});
  @override
  createState() => _LazyListScreenState();
}

class _LazyListScreenState extends State<LazyListScreen> {
  final messageTextController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  String _messageText;
  ChatBloc _dataBloc = ChatBloc();

  @override
  initState() {
    super.initState();
    _dataBloc.add(ChatEventStart(widget.conversationID));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts'),
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
      padding: EdgeInsets.fromLTRB(15, 10, 15, 0), reverse: true,
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
                onPressed: () {
                  messageTextController.clear();
                  _firestore.collection('posts').add({
                    'author': 'Alisa Bosconovitch',
                    'title': _messageText,
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
  void dispose() {
    _dataBloc.close();
    super.dispose();
  }

}