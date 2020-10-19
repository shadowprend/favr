import 'package:flutter/foundation.dart';

class Conversation {
  final bool hasread;
  final String message;
  final String time;
  final String user;
  final String documentId;

  Conversation({
    @required this.user,
    this.hasread,
    this.message,
    this.documentId,
    this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      'user': user,
      'hasread': hasread,
      'time': time,
      'message': message,
    };
  }

  static Conversation fromMap(Map<String, dynamic> map, String documentId) {
    if (map == null) return null;

    return Conversation(
      hasread: map['hasread'],
      time: map['time'],
      message: map['message'],
      user: map['user'],
      documentId: documentId,
    );
  }
}
