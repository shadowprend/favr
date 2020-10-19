part of 'message_block.dart';
abstract class MessageState extends Equatable {
  const MessageState();

  @override
  List<Object> get props => [];
}

class MessageStateLoading extends MessageState {}

class MessageStateEmpty extends MessageState {}

class MessageStateLoadSuccess extends MessageState {
  final List<Messages> posts;
  final bool hasMoreData;

  const MessageStateLoadSuccess(this.posts, this.hasMoreData);

  @override
  List<Object> get props => [posts];
}