import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failure.dart';
import '../../domain/usecases/add_task_usecase.dart';
import '../../domain/usecases/delete_task_usecase.dart';
import '../../domain/usecases/edit_task_usecase.dart';
import '../../domain/usecases/get_all_tasks.dart';
import '../../domain/usecases/pin_task_usecase.dart';
import '../../domain/usecases/set_color_code_usecase.dart';
import '../../domain/usecases/set_due_date_usecase.dart';
import '../../domain/usecases/set_reminder_usecase.dart';
import '../../domain/usecases/mark_as_notified_usecase.dart';

import '../../domain/entities/task_entity.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final AddTask addTask;
  final EditTask editTask;
  final DeleteTask deleteTask;
  final GetAllTasks getAllTasks;
  final PinTask pinTask;
  final SetColorCode setColorCode;
  final SetDueDate setDueDate;
  final SetReminder setReminder;
  final MarkAsNotified markAsNotified;
  TodoBloc({
    required this.addTask,
    required this.editTask,
    required this.deleteTask,
    required this.getAllTasks,
    required this.pinTask,
    required this.setColorCode,
    required this.setDueDate,
    required this.setReminder,
    required this.markAsNotified,
  }) : super(TodoInitial()) {
    on<LoadTodos>((event, emit) async {
      emit(TodoLoading());

      // Fetch both creator and collaborator tasks
      final result =
          await getAllTasks(event.userId, includeCollaboratorTasks: true);
      result.fold(
        (failure) => emit(TodoError(_mapFailureToMessage(failure))),
        (tasks) {
          tasks.sort(
              (a, b) => (b.isPinned ? 1 : 0).compareTo(a.isPinned ? 1 : 0));

          emit(TodoLoaded(tasks));
        },
      );
    });

    on<AddTodoEvent>((event, emit) async {
      final result = await addTask(event.task);
      result.fold(
        (failure) => emit(AddTodoFailure(_mapFailureToMessage(failure))),
        (task) {
          emit(AddTodoSuccess(task));
          Future.microtask(() => add(LoadTodos(task.creatorId)));
        },
      );
    });

    on<EditTodoEvent>((event, emit) async {
      if (state is TodoLoaded) {
        // Cast the state to TodoLoaded to access the tasks list
        final currentState = state as TodoLoaded;

        final result = await editTask(event.task);
        result.fold(
          (failure) => emit(EditTodoFailure(_mapFailureToMessage(failure))),
          (updatedTask) {
            // Update the tasks list with the edited task
            final updatedTasks = currentState.tasks.map((task) {
              return task.id == updatedTask.id ? updatedTask : task;
            }).toList();

            // Emit the updated TodoLoaded state with the modified tasks list
            emit(TodoLoaded(updatedTasks));
            emit(EditTodoSuccess(updatedTask));
          },
        );
      }
    });

    on<DeleteTodoEvent>((event, emit) async {
      final result = await deleteTask(event.taskId);
      result.fold(
          (failure) =>
              emit(TaskOperationFailure(_mapFailureToMessage(failure))), (_) {
        emit(DeleteTodoSuccess());
        Future.microtask(() => add(LoadTodos(event.userId)));
      });
    });

    on<PinTodoEvent>((event, emit) async {
      final result = await pinTask(event.task);
      result.fold(
        (failure) => emit(TaskOperationFailure(_mapFailureToMessage(failure))),
        (task) {
          add(LoadTodos(task.creatorId));
        },
      );
    });

    on<SetColorCodeEvent>((event, emit) async {
      final result = await setColorCode(event.taskId, event.colorCode);
      result.fold(
        (failure) => emit(TaskOperationFailure(_mapFailureToMessage(failure))),
        (task) => emit(TaskOperationSuccess(task)),
      );
    });

    on<SetDueDateEvent>((event, emit) async {
      final result = await setDueDate(event.taskId, event.dueDate);
      result.fold(
        (failure) => emit(TaskOperationFailure(_mapFailureToMessage(failure))),
        (task) => emit(TaskOperationSuccess(task)),
      );
    });

    on<SetReminderEvent>((event, emit) async {
      final result = await setReminder(event.taskId, event.reminderDate);
      result.fold(
        (failure) => emit(TaskOperationFailure(_mapFailureToMessage(failure))),
        (task) => emit(TaskOperationSuccess(task)),
      );
    });

    on<MarkAsNotifiedEvent>((event, emit) async {
      final result = await markAsNotified(event.taskId);
      result.fold(
        (failure) => emit(TaskOperationFailure(_mapFailureToMessage(failure))),
        (task) => emit(TaskOperationSuccess(task)),
      );
    });
  }

  String _mapFailureToMessage(Failure failure) {
    return 'An error occurred. Please try again.';
  }
}
