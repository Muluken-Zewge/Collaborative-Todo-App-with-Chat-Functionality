import 'package:dartz/dartz.dart';
import 'package:collaborative_todo_app_with_chat_functionality/core/error/failure.dart';
import 'package:collaborative_todo_app_with_chat_functionality/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:collaborative_todo_app_with_chat_functionality/features/chat/data/models/message_model.dart';

import '../../domian/entities/chat_entity.dart';
import '../../domian/entities/message_entity.dart';
import '../../domian/repositories/chat_repository.dart';
import '../models/chat_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, void>> sendMessage(Message message) async {
    try {
      final messageModel = MessageModel.fromEntity(message);
      await remoteDataSource.sendMessage(messageModel);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Message>>> fetchMessages(String chatId) async {
    try {
      final messageModels = await remoteDataSource.fetchMessages(chatId);
      final messages = messageModels.map((model) => model.toEntity()).toList();
      return Right(messages);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> setUserPresence(
      String userId, bool isOnline) async {
    try {
      await remoteDataSource.updateUserPresence(userId, isOnline);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Stream<bool>>> listenToUserPresence(
      String userId) async {
    try {
      final presenceStream = remoteDataSource.listenToUserPresence(userId);
      return Right(presenceStream);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Stream<List<Message>>>> listenToMessages(
      String chatId) async {
    try {
      final messageStream = remoteDataSource.listenToMessages(chatId).map(
          (messageModels) =>
              messageModels.map((model) => model.toEntity()).toList());
      return Right(messageStream);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateMessageReadStatus(
      String messageId, bool isRead) async {
    try {
      await remoteDataSource.updateMessageReadStatus(messageId, isRead);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Chat>>> loadChats(String userId) async {
    try {
      final chats = await remoteDataSource.loadChats(userId);
      return Right(chats.map((chat) => chat as Chat).toList());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Chat>> createChat(Chat chat) async {
    try {
      final chatModel = ChatModel.fromEntity(chat);
      await remoteDataSource.createChat(chatModel);
      return Right(chat);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteChat(String chatId) async {
    try {
      await remoteDataSource.deleteChat(chatId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Chat>>> getAllChats(
      String userId, bool isGroup) async {
    try {
      final chatModels = await remoteDataSource.getAllChats(userId, isGroup);
      final chats = chatModels.map((model) => model.toEntity()).toList();
      return Right(chats);
    } catch (e) {
      print("Error fetching chats: $e");

      return Left(ServerFailure());
    }
  }
}
