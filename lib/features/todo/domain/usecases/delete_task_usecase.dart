import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../repositories/task_repository.dart';

class DeleteTask {
  final TaskRepository repository;

  DeleteTask(this.repository);

  Future<Either<Failure, Unit>> call(String taskId) {
    return repository.deleteTask(taskId);
  }
}
