part of 'todo_bloc.dart';

sealed class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object> get props => [];
}

class LoadTodos extends TodoEvent {
  final String userId;

  const LoadTodos(this.userId);

  @override
  List<Object> get props => [userId];
}

class AddTodoEvent extends TodoEvent {
  final Task task;

  const AddTodoEvent(this.task);

  @override
  List<Object> get props => [task];
}

class EditTodoEvent extends TodoEvent {
  final Task task;

  const EditTodoEvent(this.task);

  @override
  List<Object> get props => [task];
}

class DeleteTodoEvent extends TodoEvent {
  final String taskId;
  final String userId;

  const DeleteTodoEvent(this.taskId, this.userId);

  @override
  List<Object> get props => [taskId];
}

class PinTodoEvent extends TodoEvent {
  final Task task;

  const PinTodoEvent(this.task);

  @override
  List<Object> get props => [task];
}

class SetColorCodeEvent extends TodoEvent {
  final String taskId;
  final String colorCode;

  const SetColorCodeEvent(this.taskId, this.colorCode);

  @override
  List<Object> get props => [taskId, colorCode];
}

class SetDueDateEvent extends TodoEvent {
  final String taskId;
  final DateTime dueDate;

  const SetDueDateEvent(this.taskId, this.dueDate);

  @override
  List<Object> get props => [taskId, dueDate];
}

class SetReminderEvent extends TodoEvent {
  final String taskId;
  final DateTime reminderDate;

  const SetReminderEvent(this.taskId, this.reminderDate);

  @override
  List<Object> get props => [taskId, reminderDate];
}

class MarkAsNotifiedEvent extends TodoEvent {
  final String taskId;

  const MarkAsNotifiedEvent(this.taskId);

  @override
  List<Object> get props => [taskId];
}
