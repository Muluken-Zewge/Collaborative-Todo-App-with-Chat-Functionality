part of 'chat_bloc.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class SendMessageEvent extends ChatEvent {
  final Message message;
  final String chatId;

  const SendMessageEvent(this.message, this.chatId);

  @override
  List<Object> get props => [message, chatId];
}

class FetchMessagesEvent extends ChatEvent {
  final String chatId;

  const FetchMessagesEvent(this.chatId);

  @override
  List<Object> get props => [chatId];
}

class ListenToMessagesEvent extends ChatEvent {
  final String chatId;

  const ListenToMessagesEvent(this.chatId);

  @override
  List<Object> get props => [chatId];
}

class SetUserPresenceEvent extends ChatEvent {
  final String userId;
  final bool isOnline;

  const SetUserPresenceEvent(this.userId, this.isOnline);

  @override
  List<Object> get props => [userId, isOnline];
}

class ListenToUserPresenceEvent extends ChatEvent {
  final String userId;

  const ListenToUserPresenceEvent(this.userId);

  @override
  List<Object> get props => [userId];
}

class UpdateMessageReadStatusEvent extends ChatEvent {
  final String messageId;
  final bool isRead;

  const UpdateMessageReadStatusEvent(this.messageId, this.isRead);

  @override
  List<Object> get props => [messageId, isRead];
}

class LoadChats extends ChatEvent {
  final String userId;
  final bool isGroup;

  const LoadChats(this.userId, this.isGroup);

  @override
  List<Object> get props => [userId];
}

class CreateChat extends ChatEvent {
  final Chat chat;

  const CreateChat(this.chat);
}

class DeleteChat extends ChatEvent {}
