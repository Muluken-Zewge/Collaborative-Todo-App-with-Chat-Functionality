import '../model/task_model.dart';

abstract class TaskRemoteDataSource {
  Future<void> addTask(TaskModel task);
  Future<void> editTask(TaskModel task);
  Future<void> deleteTask(String taskId);
  Future<TaskModel?> getTaskById(String taskId);
  Future<List<TaskModel>> getAllTasks(String userId,
      {bool includeCollaboratorTasks = false});
  Future<void> addCollaborator(String taskId, String collaboratorId);
  Future<void> pinTask(TaskModel task);
  Future<void> setColorCode(String taskId, String colorCode);
  Future<void> setDueDate(String taskId, DateTime dueDate);
  Future<void> setReminder(String taskId, DateTime reminderDate);
  Future<void> markAsNotified(String taskId);
}
