import 'package:collaborative_todo_app_with_chat_functionality/features/chat/data/models/message_model.dart';

import '../models/chat_model.dart';

abstract class ChatRemoteDataSource {
  Future<void> sendMessage(MessageModel message);
  Future<List<MessageModel>> fetchMessages(String chatId);
  Future<void> updateMessageReadStatus(String messageId, bool isRead);
  Future<void> updateUserPresence(String userId, bool isOnline);
  Stream<bool> listenToUserPresence(String userId);
  Stream<List<MessageModel>> listenToMessages(String chatId);
  Future<void> createChat(ChatModel chat);
  Future<List<ChatModel>> loadChats(String userId);
  Future<void> deleteChat(String chatId);
  Future<List<ChatModel>> getAllChats(String userId, bool isGroup);
}
