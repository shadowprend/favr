part of 'chat_block.dart';
abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class DataStateLoading extends ChatState {}

class DataStateEmpty extends ChatState {}

class DataStateLoadSuccess extends ChatState {
  final List<ChatMessage> posts;
  final bool hasMoreData;

  const DataStateLoadSuccess(this.posts, this.hasMoreData);

  @override
  List<Object> get props => [posts];
}