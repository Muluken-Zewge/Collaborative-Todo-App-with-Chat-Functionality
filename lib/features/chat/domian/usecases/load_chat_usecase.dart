import 'package:dartz/dartz.dart';
import 'package:collaborative_todo_app_with_chat_functionality/core/error/failure.dart';
import '../entities/chat_entity.dart';
import '../repositories/chat_repository.dart';

class LoadChats {
  final ChatRepository repository;

  LoadChats(this.repository);

  Future<Either<Failure, List<Chat>>> call(String userId) async {
    return await repository.loadChats(userId);
  }
}
