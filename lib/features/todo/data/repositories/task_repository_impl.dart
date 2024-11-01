import 'package:dartz/dartz.dart' as dartz;
import '../../../../core/error/failure.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasource/task_remote_data_source.dart';
import '../model/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remoteDataSource;

  TaskRepositoryImpl(this.remoteDataSource);

  @override
  Future<dartz.Either<Failure, Task>> addTask(Task task) async {
    try {
      final taskModel = TaskModel.fromEntity(task);
      await remoteDataSource.addTask(taskModel);
      return dartz.Right(taskModel);
    } catch (e) {
      return dartz.Left(ServerFailure());
    }
  }

  @override
  Future<dartz.Either<Failure, Task>> editTask(Task task) async {
    try {
      final taskModel = TaskModel.fromEntity(task);
      await remoteDataSource.editTask(taskModel);
      return dartz.Right(taskModel);
    } catch (e) {
      return dartz.Left(ServerFailure());
    }
  }

  @override
  Future<dartz.Either<Failure, dartz.Unit>> deleteTask(String taskId) async {
    try {
      await remoteDataSource.deleteTask(taskId);
      return const dartz.Right(
          dartz.unit); // unit represents a void type in Dartz
    } catch (e) {
      return dartz.Left(ServerFailure());
    }
  }

  @override
  Future<dartz.Either<Failure, Task>> getTaskById(String taskId) async {
    try {
      final taskModel = await remoteDataSource.getTaskById(taskId);
      if (taskModel != null) {
        return dartz.Right(taskModel.toEntity());
      } else {
        return dartz.Left(
            ServerFailure()); // Return a failure if task doesn't exist
      }
    } catch (e) {
      return dartz.Left(ServerFailure());
    }
  }

  @override
  Future<dartz.Either<Failure, List<Task>>> getAllTasks(String userId,
      {bool includeCollaboratorTasks = false}) async {
    try {
      final taskModels = await remoteDataSource.getAllTasks(userId,
          includeCollaboratorTasks: includeCollaboratorTasks);
      final tasks = taskModels.map((model) => model.toEntity()).toList();
      return dartz.Right(tasks);
    } catch (e) {
      return dartz.Left(ServerFailure());
    }
  }

  @override
  Future<dartz.Either<Failure, Task>> addCollaborator(
      String taskId, String collaboratorId) async {
    try {
      await remoteDataSource.addCollaborator(taskId, collaboratorId);
      final updatedTask = await remoteDataSource.getTaskById(taskId);
      return dartz.Right(updatedTask!.toEntity());
    } catch (e) {
      return dartz.Left(ServerFailure());
    }
  }

  @override
  Future<dartz.Either<Failure, Task>> pinTask(Task task) async {
    try {
      final taskModel = TaskModel.fromEntity(task);

      await remoteDataSource.pinTask(taskModel);
      final updatedTask = await remoteDataSource.getTaskById(task.creatorId);
      return dartz.Right(updatedTask!.toEntity());
    } catch (e) {
      return dartz.Left(ServerFailure());
    }
  }

  @override
  Future<dartz.Either<Failure, Task>> setColorCode(
      String taskId, String colorCode) async {
    try {
      await remoteDataSource.setColorCode(taskId, colorCode);
      final updatedTask = await remoteDataSource.getTaskById(taskId);
      return dartz.Right(updatedTask!.toEntity());
    } catch (e) {
      return dartz.Left(ServerFailure());
    }
  }

  @override
  Future<dartz.Either<Failure, Task>> setDueDate(
      String taskId, DateTime dueDate) async {
    try {
      await remoteDataSource.setDueDate(taskId, dueDate);
      final updatedTask = await remoteDataSource.getTaskById(taskId);
      return dartz.Right(updatedTask!.toEntity());
    } catch (e) {
      return dartz.Left(ServerFailure());
    }
  }

  @override
  Future<dartz.Either<Failure, Task>> setReminder(
      String taskId, DateTime reminderDate) async {
    try {
      await remoteDataSource.setReminder(taskId, reminderDate);
      final updatedTask = await remoteDataSource.getTaskById(taskId);
      return dartz.Right(updatedTask!.toEntity());
    } catch (e) {
      return dartz.Left(ServerFailure());
    }
  }

  @override
  Future<dartz.Either<Failure, Task>> markAsNotified(String taskId) async {
    try {
      await remoteDataSource.markAsNotified(taskId);
      final updatedTask = await remoteDataSource.getTaskById(taskId);
      return dartz.Right(updatedTask!.toEntity());
    } catch (e) {
      return dartz.Left(ServerFailure());
    }
  }
}
