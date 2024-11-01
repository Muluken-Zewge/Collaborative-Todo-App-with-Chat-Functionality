class Task {
  final String id;
  final String title;
  final String description;
  final String creatorId;
  final List<String> collaboratorIds;
  final DateTime? dueDate;
  final DateTime? reminderDate;
  final bool isPinned;
  final String colorCode;
  final bool isCompleted;
  final bool isNotified;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.creatorId,
    this.collaboratorIds = const [],
    this.dueDate,
    this.reminderDate,
    this.isPinned = false,
    this.colorCode = "#FFFFFF",
    this.isCompleted = false,
    this.isNotified = false,
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    String? creatorId,
    List<String>? collaboratorIds,
    DateTime? dueDate,
    DateTime? reminderDate,
    bool? isPinned,
    String? colorCode,
    bool? isCompleted,
    bool? isNotified,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      creatorId: creatorId ?? this.creatorId,
      collaboratorIds: collaboratorIds ?? this.collaboratorIds,
      dueDate: dueDate ?? this.dueDate,
      reminderDate: reminderDate ?? this.reminderDate,
      isPinned: isPinned ?? this.isPinned,
      colorCode: colorCode ?? this.colorCode,
      isCompleted: isCompleted ?? this.isCompleted,
      isNotified: isNotified ?? this.isNotified,
    );
  }
}
