import 'package:dartz/dartz.dart' as dartz;
import '../../../../core/error/failure.dart';
import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

class SetColorCode {
  final TaskRepository repository;

  SetColorCode(this.repository);

  Future<dartz.Either<Failure, Task>> call(String taskId, String colorCode) {
    return repository.setColorCode(taskId, colorCode);
  }
}
