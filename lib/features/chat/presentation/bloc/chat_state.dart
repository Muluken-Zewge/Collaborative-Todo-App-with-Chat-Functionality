part of 'chat_bloc.dart';

sealed class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

final class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<Chat> chats;

  const ChatLoaded(this.chats);

  @override
  List<Object> get props => [chats];
}

class ChatError extends ChatState {
  final String message;

  const ChatError(this.message);
}

class ChatCreated extends ChatState {
  final Chat chat;

  const ChatCreated(this.chat);
}

class ChatListening extends ChatState {
  final Stream<List<Message>> messageStream;

  const ChatListening(this.messageStream);
}

class UserPresenceUpdated extends ChatState {
  final Map<String, bool> presenceStatus;

  const UserPresenceUpdated(this.presenceStatus);
}

class MessageSent extends ChatState {}

class MessageReadStatusUpdated extends ChatState {}

class MessageLoading extends ChatState {}

class MessageLoaded extends ChatState {
  final List<Message> messages;

  const MessageLoaded(this.messages);
}
