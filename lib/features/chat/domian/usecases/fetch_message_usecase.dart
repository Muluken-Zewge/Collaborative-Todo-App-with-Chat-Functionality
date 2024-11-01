import 'package:dartz/dartz.dart';
import 'package:collaborative_todo_app_with_chat_functionality/core/error/failure.dart';

import '../entities/message_entity.dart';
import '../repositories/chat_repository.dart';

class FetchMessages {
  final ChatRepository repository;

  FetchMessages(this.repository);

  Future<Either<Failure, List<Message>>> call(String chatId) async {
    return await repository.fetchMessages(chatId);
  }
}
