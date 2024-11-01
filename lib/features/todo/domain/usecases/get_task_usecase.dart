import 'package:dartz/dartz.dart' as dartz;
import '../../../../core/error/failure.dart';
import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

class GetTaskById {
  final TaskRepository repository;

  GetTaskById(this.repository);

  Future<dartz.Either<Failure, Task>> call(String taskId) {
    return repository.getTaskById(taskId);
  }
}
