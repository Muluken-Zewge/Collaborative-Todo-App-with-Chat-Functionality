import 'package:collaborative_todo_app_with_chat_functionality/core/constants/constants.dart';
import 'package:collaborative_todo_app_with_chat_functionality/features/auth/domain/entities/auth_user.dart';
import 'package:collaborative_todo_app_with_chat_functionality/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../widgets/add_todo_form.dart';
import '../widgets/edit_todo_form.dart';

class TodoScreen extends StatefulWidget {
  final AuthUser authUser;
  const TodoScreen({super.key, required this.authUser});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  bool isGridView = false;

  void _toggleView() {
    setState(() {
      isGridView = !isGridView;
    });
  }

  Color _getColorFromHex(String hexColor) {
    return Color(int.parse(hexColor.replaceFirst('#', '0xff')));
  }

  Color _getTextColor(String hexColor) {
    return hexColor.toUpperCase() == "#FFFFFF" ? Colors.black : Colors.white;
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM d').format(date);
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('MMM d, hh:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos'),
        actions: [
          IconButton(
            icon: Icon(isGridView ? Icons.view_list : Icons.grid_view),
            onPressed: _toggleView,
          ),
        ],
      ),
      body: BlocListener<TodoBloc, TodoState>(
        listener: (context, state) {
          if (state is AddTodoSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Todo added successfully!")),
            );
          } else if (state is AddTodoFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Failed to add todo: ${state.message}")),
            );
          } else if (state is EditTodoSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Todo edited successfully!")),
            );
          } else if (state is EditTodoFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Failed to edit todo: ${state.message}")),
            );
          } else if (state is DeleteTodoSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Todo deleted successfully!")),
            );
            Navigator.pop(context);
          }
        },
        child: BlocBuilder<TodoBloc, TodoState>(
          builder: (context, state) {
            if (state is TodoLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TodoLoaded) {
              if (state.tasks.isEmpty) {
                return const Center(
                  child: Text("You don't have any todos currently."),
                );
              } else {
                return isGridView
                    ? GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 3 / 2,
                        ),
                        itemCount: state.tasks.length,
                        itemBuilder: (context, index) {
                          final task = state.tasks[index];
                          final textColor = _getTextColor(task.colorCode);

                          return GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (context) => EditTodoForm(
                                    authUser: widget.authUser, task: task),
                              );
                            },
                            child: Card(
                              elevation: 4,
                              color: _getColorFromHex(task.colorCode),
                              child: Stack(
                                children: [
                                  ListTile(
                                    title: Text(task.title,
                                        style: TextStyle(color: textColor)),
                                    subtitle: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(task.description,
                                            style: TextStyle(color: textColor)),
                                        if (task.dueDate != null)
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 4),
                                            child: Row(
                                              children: [
                                                const Icon(Icons.calendar_today,
                                                    size: 16,
                                                    color: Colors.orange),
                                                const SizedBox(width: 4),
                                                Text(
                                                  _formatDate(task.dueDate!),
                                                  style: TextStyle(
                                                      color: textColor),
                                                ),
                                              ],
                                            ),
                                          ),
                                        if (task.reminderDate != null)
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 4),
                                            child: Row(
                                              children: [
                                                const Icon(Icons.watch_later,
                                                    size: 16,
                                                    color: Colors.blue),
                                                const SizedBox(width: 4),
                                                Text(
                                                  _formatDateTime(
                                                      task.reminderDate!),
                                                  style: TextStyle(
                                                      color: textColor),
                                                ),
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  if (task.isPinned)
                                    const Positioned(
                                        top: 8,
                                        right: 8,
                                        child: Icon(Icons.push_pin)),
                                  if (task.collaboratorIds.isNotEmpty)
                                    Positioned(
                                      bottom: 8,
                                      right: 8,
                                      child: CircleAvatar(
                                        radius: 15, // Smaller avatar size
                                        backgroundColor: Colors.grey[300],
                                        child: const Icon(Icons.person,
                                            size: 12, color: Colors.black),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : ListView.builder(
                        itemCount: state.tasks.length,
                        itemBuilder: (context, index) {
                          final task = state.tasks[index];
                          final textColor = _getTextColor(task.colorCode);

                          return GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (context) => EditTodoForm(
                                    authUser: widget.authUser, task: task),
                              );
                            },
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              color: _getColorFromHex(task.colorCode),
                              child: Stack(children: [
                                ListTile(
                                  title: Text(
                                    task.title,
                                    style: TextStyle(color: textColor),
                                  ),
                                  subtitle: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(task.description,
                                          style: TextStyle(color: textColor)),
                                      if (task.dueDate != null)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4),
                                          child: Row(
                                            children: [
                                              const Icon(Icons.calendar_today,
                                                  size: 16,
                                                  color: Colors.orange),
                                              const SizedBox(width: 4),
                                              Text(
                                                _formatDate(task.dueDate!),
                                                style:
                                                    TextStyle(color: textColor),
                                              ),
                                            ],
                                          ),
                                        ),
                                      if (task.reminderDate != null)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4),
                                          child: Row(
                                            children: [
                                              const Icon(Icons.watch_later,
                                                  size: 16, color: Colors.blue),
                                              const SizedBox(width: 4),
                                              Text(
                                                _formatDateTime(
                                                    task.reminderDate!),
                                                style:
                                                    TextStyle(color: textColor),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                if (task.isPinned)
                                  const Positioned(
                                      top: 8,
                                      right: 8,
                                      child: Icon(Icons.push_pin)),
                                if (task.collaboratorIds.isNotEmpty)
                                  Positioned(
                                    bottom: 8,
                                    right: 8,
                                    child: CircleAvatar(
                                      radius: 15, // Smaller avatar size
                                      backgroundColor: Colors.grey[300],
                                      child: const Icon(Icons.person,
                                          size: 12, color: Colors.black),
                                    ),
                                  ),
                              ]),
                            ),
                          );
                        },
                      );
              }
            } else if (state is TodoError) {
              return Center(child: Text(state.message));
            }
            return const Center(
                child: Text("You don't have any todos currently."));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) => AddTodoForm(
                    authUser: widget.authUser,
                  ));
        },
        child: const Icon(
          Icons.add,
          color: primaryLightColor,
        ),
      ),
    );
  }
}
