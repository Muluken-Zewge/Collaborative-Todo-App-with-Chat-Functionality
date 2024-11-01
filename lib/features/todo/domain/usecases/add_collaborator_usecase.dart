import 'package:dartz/dartz.dart' as dartz;
import '../../../../core/error/failure.dart';
import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

class AddCollaborator {
  final TaskRepository repository;

  AddCollaborator(this.repository);

  Future<dartz.Either<Failure, Task>> call(
      String taskId, String collaboratorId) {
    return repository.addCollaborator(taskId, collaboratorId);
  }
}
