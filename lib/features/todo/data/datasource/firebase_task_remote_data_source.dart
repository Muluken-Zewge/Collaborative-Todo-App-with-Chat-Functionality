import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/task_model.dart';
import 'task_remote_data_source.dart';

class FirebaseTaskRemoteDataSource implements TaskRemoteDataSource {
  final FirebaseFirestore firestore;

  FirebaseTaskRemoteDataSource(this.firestore);

  @override
  Future<void> addTask(TaskModel task) async {
    try {
      await firestore.collection('tasks').doc(task.id).set(task.toJson());
    } catch (e) {
      throw Exception('Error adding task: $e');
    }
  }

  @override
  Future<void> editTask(TaskModel task) async {
    try {
      await firestore.collection('tasks').doc(task.id).update(task.toJson());
    } catch (e) {
      throw Exception('Error editing task: $e');
    }
  }

  @override
  Future<void> deleteTask(String taskId) async {
    try {
      await firestore.collection('tasks').doc(taskId).delete();
    } catch (e) {
      throw Exception('Error deleting task: $e');
    }
  }

  @override
  Future<TaskModel?> getTaskById(String taskId) async {
    try {
      final doc = await firestore.collection('tasks').doc(taskId).get();
      if (doc.exists) {
        return TaskModel.fromJson(doc.data()!);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Error getting task by ID: $e');
    }
  }

  @override
  Future<List<TaskModel>> getAllTasks(String userId,
      {bool includeCollaboratorTasks = false}) async {
    try {
      List<TaskModel> allTasks = [];

      // Fetch tasks created by the user
      final creatorTasksSnapshot = await firestore
          .collection('tasks')
          .where('creatorId', isEqualTo: userId)
          .get();
      allTasks.addAll(
        creatorTasksSnapshot.docs.map((doc) => TaskModel.fromJson(doc.data())),
      );

      if (!includeCollaboratorTasks) {
        // Fetch tasks where user is a collaborator
        final collaboratorTasksSnapshot = await firestore
            .collection('tasks')
            .where('collaboratorIds', arrayContains: userId)
            .get();
        allTasks.addAll(
          collaboratorTasksSnapshot.docs
              .map((doc) => TaskModel.fromJson(doc.data())),
        );
      }

      return allTasks;
    } catch (e) {
      throw Exception('Error getting all tasks: $e');
    }
  }

  @override
  Future<void> addCollaborator(String taskId, String collaboratorId) async {
    try {
      final taskRef = firestore.collection('tasks').doc(taskId);
      await taskRef.update({
        'collaboratorIds': FieldValue.arrayUnion([collaboratorId])
      });
    } catch (e) {
      throw Exception('Error adding collaborator: $e');
    }
  }

  @override
  Future<void> pinTask(TaskModel task) async {
    try {
      await firestore
          .collection('tasks')
          .doc(task.creatorId)
          .update({'isPinned': task.isPinned});
    } catch (e) {
      throw Exception('Error pinning task: $e');
    }
  }

  @override
  Future<void> setColorCode(String taskId, String colorCode) async {
    try {
      await firestore
          .collection('tasks')
          .doc(taskId)
          .update({'colorCode': colorCode});
    } catch (e) {
      throw Exception('Error setting color code: $e');
    }
  }

  @override
  Future<void> setDueDate(String taskId, DateTime dueDate) async {
    try {
      await firestore.collection('tasks').doc(taskId).update({
        'dueDate': dueDate.toIso8601String(),
      });
    } catch (e) {
      throw Exception('Error setting due date: $e');
    }
  }

  @override
  Future<void> setReminder(String taskId, DateTime reminderDate) async {
    try {
      await firestore.collection('tasks').doc(taskId).update({
        'reminderDate': reminderDate.toIso8601String(),
      });
    } catch (e) {
      throw Exception('Error setting reminder: $e');
    }
  }

  @override
  Future<void> markAsNotified(String taskId) async {
    try {
      await firestore
          .collection('tasks')
          .doc(taskId)
          .update({'isNotified': true});
    } catch (e) {
      throw Exception('Error marking as notified: $e');
    }
  }
}
