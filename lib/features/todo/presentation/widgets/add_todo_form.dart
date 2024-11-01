import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collaborative_todo_app_with_chat_functionality/features/auth/domain/entities/auth_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../../data/datasource/firebase_task_remote_data_source.dart';
import '../../data/repositories/task_repository_impl.dart';
import '../../domain/entities/task_entity.dart';
import '../bloc/todo_bloc.dart';

class AddTodoForm extends StatefulWidget {
  final AuthUser authUser;

  const AddTodoForm({super.key, required this.authUser});

  @override
  State<AddTodoForm> createState() => _AddTodoFormState();
}

class _AddTodoFormState extends State<AddTodoForm> {
  late final TaskRepositoryImpl taskRepository;

  @override
  void initState() {
    super.initState();

    final taskRemoteDataSource =
        FirebaseTaskRemoteDataSource(FirebaseFirestore.instance);
    taskRepository = TaskRepositoryImpl(taskRemoteDataSource);
  }

  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();

  final _descriptionController = TextEditingController();

  DateTime? _dueDate;

  DateTime? _reminderDate;

  Color _selectedColor = Colors.white;

  bool _isPinned = false;

  final List<String> _collaborators = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _showCollaboratorSearch() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return CollaboratorSearch(
          onAddCollaborator: _addCollaborator,
          firestore: _firestore,
        );
      },
    );
  }

  void _addCollaborator(Map<String, dynamic> collaborator) {
    setState(() {
      _collaborators.add(collaborator['userId']);
    });
    Navigator.pop(context); // Close the modal after adding
  }

  void _openColorPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pick a Color'),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: _selectedColor,
              onColorChanged: (color) {
                setState(() {
                  _selectedColor = color;
                });
              },
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Select'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 20,
        left: 20,
        right: 20,
      ),
      child: FocusScope(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'New Todo',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: Icon(
                          _isPinned ? Icons.push_pin : Icons.push_pin_outlined),
                      onPressed: () {
                        setState(() {
                          _isPinned = !_isPinned;
                        });
                      },
                    ),
                  ],
                ),
                TextFormField(
                  autofocus: false,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  autofocus: false,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () async {
                        _dueDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.notifications),
                      onPressed: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (selectedDate != null) {
                          final selectedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (selectedTime != null) {
                            setState(() {
                              _reminderDate = DateTime(
                                selectedDate.year,
                                selectedDate.month,
                                selectedDate.day,
                                selectedTime.hour,
                                selectedTime.minute,
                              );
                            });
                          }
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.person_add),
                      onPressed: _showCollaboratorSearch,
                    ),
                    IconButton(
                      icon: const Icon(Icons.color_lens),
                      onPressed: () => _openColorPicker(context),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      final task = Task(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          title: _titleController.text,
                          description: _descriptionController.text,
                          creatorId: widget.authUser.id,
                          dueDate: _dueDate,
                          reminderDate: _reminderDate,
                          isPinned: _isPinned,
                          colorCode:
                              '#${_selectedColor.value.toRadixString(16).substring(2)}',
                          collaboratorIds: _collaborators);

                      context.read<TodoBloc>().add(AddTodoEvent(task));
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Save Todo'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CollaboratorSearch extends StatefulWidget {
  final Function(Map<String, dynamic>) onAddCollaborator;
  final FirebaseFirestore firestore;

  const CollaboratorSearch({
    super.key,
    required this.onAddCollaborator,
    required this.firestore,
  });

  @override
  State<CollaboratorSearch> createState() => _CollaboratorSearchState();
}

class _CollaboratorSearchState extends State<CollaboratorSearch> {
  final _collaboratorController = TextEditingController();
  List<Map<String, dynamic>> _autocompleteResults = [];

  void _searchCollaborators(String query) async {
    if (query.isEmpty) return;

    final results = await widget.firestore
        .collection('users')
        .where('email', isGreaterThanOrEqualTo: query)
        .where('email', isLessThanOrEqualTo: "$query\uf8ff")
        .get();

    setState(() {
      _autocompleteResults = results.docs
          .map((doc) => {
                'userId': doc.id,
                'email': doc['email'],
                'userName': doc['userName'],
              })
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 20,
        left: 20,
        right: 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _collaboratorController,
              decoration: const InputDecoration(
                labelText: 'Search Collaborator by Email',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _searchCollaborators,
            ),
            ..._autocompleteResults.map((collaborator) {
              return ListTile(
                leading: CircleAvatar(
                  child: Text(collaborator['userName']!.substring(0, 2)),
                ),
                title: Text(collaborator['email']!),
                subtitle: Text(collaborator['userName']!),
                onTap: () => widget.onAddCollaborator(collaborator),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
