import 'package:dartz/dartz.dart' as dartz;
import '../../../../core/error/failure.dart';
import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

class EditTask {
  final TaskRepository repository;

  EditTask(this.repository);

  Future<dartz.Either<Failure, Task>> call(Task task) {
    return repository.editTask(task);
  }
}
