import 'package:dartz/dartz.dart';
import 'package:collaborative_todo_app_with_chat_functionality/core/error/failure.dart';
import '../repositories/chat_repository.dart';

class DeleteChat {
  final ChatRepository repository;

  DeleteChat(this.repository);

  Future<Either<Failure, void>> call(String chatId) async {
    return await repository.deleteChat(chatId);
  }
}
