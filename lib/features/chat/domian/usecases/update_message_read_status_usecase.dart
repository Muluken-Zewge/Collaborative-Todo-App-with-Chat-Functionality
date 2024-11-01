import 'package:dartz/dartz.dart';
import 'package:collaborative_todo_app_with_chat_functionality/core/error/failure.dart';

import '../repositories/chat_repository.dart';

class UpdateMessageReadStatus {
  final ChatRepository repository;

  UpdateMessageReadStatus(this.repository);

  Future<Either<Failure, void>> call(String messageId, bool isRead) async {
    return await repository.updateMessageReadStatus(messageId, isRead);
  }
}
