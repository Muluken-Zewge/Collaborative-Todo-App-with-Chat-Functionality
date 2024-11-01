import 'package:dartz/dartz.dart';
import 'package:collaborative_todo_app_with_chat_functionality/core/error/failure.dart';

import '../repositories/chat_repository.dart';

class ListenToUserPresence {
  final ChatRepository repository;

  ListenToUserPresence(this.repository);

  Future<Either<Failure, Stream<bool>>> call(String userId) async {
    return await repository.listenToUserPresence(userId);
  }
}
