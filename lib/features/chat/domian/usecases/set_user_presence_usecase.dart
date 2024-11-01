import 'package:dartz/dartz.dart';
import 'package:collaborative_todo_app_with_chat_functionality/core/error/failure.dart';
import '../repositories/chat_repository.dart';

class SetUserPresence {
  final ChatRepository repository;

  SetUserPresence(this.repository);

  Future<Either<Failure, void>> call(String userId, bool isOnline) async {
    return await repository.setUserPresence(userId, isOnline);
  }
}
