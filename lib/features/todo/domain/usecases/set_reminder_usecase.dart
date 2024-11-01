import 'package:dartz/dartz.dart' as dartz;
import '../../../../core/error/failure.dart';
import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

class SetReminder {
  final TaskRepository repository;

  SetReminder(this.repository);

  Future<dartz.Either<Failure, Task>> call(
      String taskId, DateTime reminderDate) {
    return repository.setReminder(taskId, reminderDate);
  }
}
