import 'package:dartz/dartz.dart';
import 'package:collaborative_todo_app_with_chat_functionality/core/error/failure.dart';
import '../entities/chat_entity.dart';
import '../entities/message_entity.dart';

abstract class ChatRepository {
  // Sends a message in a chat (single or group)
  Future<Either<Failure, void>> sendMessage(Message message);

  // Fetches chat messages
  Future<Either<Failure, List<Message>>> fetchMessages(String chatId);

  // Sets the online/offline status of a user
  Future<Either<Failure, void>> setUserPresence(String userId, bool isOnline);

  // Listens to presence changes
  Future<Either<Failure, Stream<bool>>> listenToUserPresence(String userId);

  // Listens for new messages in real-time
  Future<Either<Failure, Stream<List<Message>>>> listenToMessages(
      String chatId);

  // Marks a message as read
  Future<Either<Failure, void>> updateMessageReadStatus(
      String messageId, bool isRead);

  // Loads a list of chats for the user
  Future<Either<Failure, List<Chat>>> loadChats(String userId);

  // Creates a new chat (either private or group)
  Future<Either<Failure, Chat>> createChat(Chat chat);

  // Deletes a specified chat
  Future<Either<Failure, void>> deleteChat(String chatId);

  Future<Either<Failure, List<Chat>>> getAllChats(String userId, bool isGroup);
}
