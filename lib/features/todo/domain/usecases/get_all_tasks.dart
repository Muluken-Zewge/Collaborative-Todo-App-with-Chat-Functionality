import 'package:dartz/dartz.dart' as dartz;
import '../../../../core/error/failure.dart';
import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

class GetAllTasks {
  final TaskRepository repository;

  GetAllTasks(this.repository);

  Future<dartz.Either<Failure, List<Task>>> call(String userId,
      {bool includeCollaboratorTasks = false}) {
    return repository.getAllTasks(userId);
  }
}
