import 'package:dartz/dartz.dart';
import 'package:collaborative_todo_app_with_chat_functionality/core/error/failure.dart';
import '../entities/chat_entity.dart';
import '../repositories/chat_repository.dart';

class CreateChatUsecase {
  final ChatRepository repository;

  CreateChatUsecase(this.repository);

  Future<Either<Failure, Chat>> call(Chat chat) async {
    return await repository.createChat(chat);
  }
}
