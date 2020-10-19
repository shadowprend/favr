part of 'message_block.dart';

abstract class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object> get props => [];

}

class MessageEventStart extends MessageEvent {}

class MessageEventLoad extends MessageEvent {
  final List<List<Messages>> data;

  const MessageEventLoad(this.data);

  @override
  List<Object> get props => [data];
}

class MessageEventFetchMore extends MessageEvent {}
