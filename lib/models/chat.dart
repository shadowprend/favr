import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Chat extends Equatable {
  final bool hasread;
  final String message;
  final Timestamp time;
  final String user;

  const Chat(this.hasread, this.message, this.time, this.user);

  factory Chat.fromSnapshot(Map data) {
    return Chat(data['hasread'], data['message'], data['time'], data['user']);
  }

  @override
  List<Object> get props => [hasread, message, time, user];
}