part of 'chat_block.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];

}

class ChatEventStart extends ChatEvent {

  final String conversationID;

  const ChatEventStart(this.conversationID);

  String get key => conversationID;
}

class ChatEventLoad extends ChatEvent {
  final List<List<ChatMessage>> data;

  const ChatEventLoad(this.data);

  @override
  List<Object> get props => [data];
}

class ChatEventFetchMore extends ChatEvent {
  final String conversationID;

  const ChatEventFetchMore(this.conversationID);

  String get key => conversationID;
}

class NewMessage extends ChatEvent {}