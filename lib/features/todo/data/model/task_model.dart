import '../../domain/entities/task_entity.dart';

class TaskModel extends Task {
  TaskModel({
    required super.id,
    required super.title,
    required super.description,
    required super.creatorId,
    super.collaboratorIds,
    super.dueDate,
    super.reminderDate,
    super.isPinned,
    super.colorCode,
    super.isCompleted,
    super.isNotified,
  });

  /// Factory constructor to create a TaskModel from JSON data.
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      creatorId: json['creatorId'] as String,
      collaboratorIds: List<String>.from(json['collaboratorIds'] ?? []),
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      reminderDate: json['reminderDate'] != null
          ? DateTime.parse(json['reminderDate'])
          : null,
      isPinned: json['isPinned'] as bool? ?? false,
      colorCode: json['colorCode'] as String? ?? "#FFFFFF",
      isCompleted: json['isCompleted'] as bool? ?? false,
      isNotified: json['isNotified'] as bool? ?? false,
    );
  }

  /// Method to convert TaskModel into JSON for Firebase storage.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'creatorId': creatorId,
      'collaboratorIds': collaboratorIds,
      'dueDate': dueDate?.toIso8601String(),
      'reminderDate': reminderDate?.toIso8601String(),
      'isPinned': isPinned,
      'colorCode': colorCode,
      'isCompleted': isCompleted,
      'isNotified': isNotified,
    };
  }

  /// Factory constructor to create a TaskModel from a Task entity.
  factory TaskModel.fromEntity(Task task) {
    return TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      creatorId: task.creatorId,
      collaboratorIds: task.collaboratorIds,
      dueDate: task.dueDate,
      reminderDate: task.reminderDate,
      isPinned: task.isPinned,
      colorCode: task.colorCode,
      isCompleted: task.isCompleted,
      isNotified: task.isNotified,
    );
  }

  /// Method to convert TaskModel back to Task entity.
  Task toEntity() {
    return Task(
      id: id,
      title: title,
      description: description,
      creatorId: creatorId,
      collaboratorIds: collaboratorIds,
      dueDate: dueDate,
      reminderDate: reminderDate,
      isPinned: isPinned,
      colorCode: colorCode,
      isCompleted: isCompleted,
      isNotified: isNotified,
    );
  }
}
