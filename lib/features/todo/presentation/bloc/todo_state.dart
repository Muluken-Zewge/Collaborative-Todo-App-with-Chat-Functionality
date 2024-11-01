part of 'todo_bloc.dart';

sealed class TodoState extends Equatable {
  const TodoState();

  @override
  List<Object> get props => [];
}

final class TodoInitial extends TodoState {}

class TodoLoading extends TodoState {}

class TodoLoaded extends TodoState {
  final List<Task> tasks;

  const TodoLoaded(this.tasks);

  @override
  List<Object> get props => [tasks];
}

class TodoError extends TodoState {
  final String message;

  const TodoError(this.message);

  @override
  List<Object> get props => [message];
}

class AddTodoSuccess extends TodoState {
  final Task task;

  const AddTodoSuccess(this.task);

  @override
  List<Object> get props => [task];
}

class AddTodoFailure extends TodoState {
  final String message;

  const AddTodoFailure(this.message);

  @override
  List<Object> get props => [message];
}

class TaskOperationSuccess extends TodoState {
  final Task task;

  const TaskOperationSuccess(this.task);
}

class TaskOperationFailure extends TodoState {
  final String message;

  const TaskOperationFailure(this.message);

  @override
  List<Object> get props => [message];
}

class EditTodoSuccess extends TodoState {
  final Task task;

  const EditTodoSuccess(this.task);
}

class EditTodoFailure extends TodoState {
  final String message;

  const EditTodoFailure(this.message);
  @override
  List<Object> get props => [message];
}

class DeleteTodoSuccess extends TodoState {}
