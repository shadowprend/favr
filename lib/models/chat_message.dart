import 'package:favr/chatblocs/chat_block.dart';
import 'package:favr/screens/chatdetailpage.dart';
import 'package:flutter/cupertino.dart';

class ChatMessage {
  String message;
  MessageType type;
  ChatMessage({@required this.message, @required this.type});
}
