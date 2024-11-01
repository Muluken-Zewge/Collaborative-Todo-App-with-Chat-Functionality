import 'package:dartz/dartz.dart' as dartz;
import '../../../../core/error/failure.dart';
import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

class SetDueDate {
  final TaskRepository repository;

  SetDueDate(this.repository);

  Future<dartz.Either<Failure, Task>> call(String taskId, DateTime dueDate) {
    return repository.setDueDate(taskId, dueDate);
  }
}
