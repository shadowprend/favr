import 'package:equatable/equatable.dart';

class Messages extends Equatable {
  final List<dynamic> id;
  final String conversationID;
  final String recentMessage;
  final String recentTime;

  const Messages(this.id,this.conversationID, this.recentMessage, this.recentTime);

  factory Messages.fromSnapshot(Map data) {
    return Messages(data['id'],data['conversationID'], data['recentMessage'], data['recentTime']);
  }

  @override
  List<Object> get props => [id, recentMessage, recentTime];
}