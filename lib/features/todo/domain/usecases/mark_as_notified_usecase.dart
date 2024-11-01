import 'package:dartz/dartz.dart' as dartz;
import '../../../../core/error/failure.dart';
import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

class MarkAsNotified {
  final TaskRepository repository;

  MarkAsNotified(this.repository);

  Future<dartz.Either<Failure, Task>> call(String taskId) {
    return repository.markAsNotified(taskId);
  }
}
