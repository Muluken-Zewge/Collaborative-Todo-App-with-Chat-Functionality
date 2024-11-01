import 'package:dartz/dartz.dart' as dartz;
import '../entities/task_entity.dart';
import '../../../../core/error/failure.dart';

abstract class TaskRepository {
  Future<dartz.Either<Failure, Task>> addTask(Task task);

  Future<dartz.Either<Failure, Task>> editTask(Task task);

  Future<dartz.Either<Failure, dartz.Unit>> deleteTask(String taskId);

  Future<dartz.Either<Failure, Task>> getTaskById(String taskId);

  Future<dartz.Either<Failure, List<Task>>> getAllTasks(String userId,
      {bool includeCollaboratorTasks = false});

  Future<dartz.Either<Failure, Task>> addCollaborator(
      String taskId, String collaboratorId);

  Future<dartz.Either<Failure, Task>> pinTask(Task task);

  Future<dartz.Either<Failure, Task>> setColorCode(
      String taskId, String colorCode);

  Future<dartz.Either<Failure, Task>> setDueDate(
      String taskId, DateTime dueDate);

  Future<dartz.Either<Failure, Task>> setReminder(
      String taskId, DateTime reminderDate);

  Future<dartz.Either<Failure, Task>> markAsNotified(String taskId);
}
