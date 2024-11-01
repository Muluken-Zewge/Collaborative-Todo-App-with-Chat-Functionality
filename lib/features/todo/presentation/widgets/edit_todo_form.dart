import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collaborative_todo_app_with_chat_functionality/features/auth/domain/entities/auth_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../../domain/entities/task_entity.dart';
import '../bloc/todo_bloc.dart';

class EditTodoForm extends StatefulWidget {
  final AuthUser authUser;
  final Task task;
  const EditTodoForm({super.key, required this.authUser, required this.task});

  @override
  State<EditTodoForm> createState() => _EditTodoFormState();
}

class _EditTodoFormState extends State<EditTodoForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  DateTime? _dueDate;
  DateTime? _reminderDate;
  late Color _selectedColor;
  bool _isPinned = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<Map<String, String>> _collaborators = [];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController =
        TextEditingController(text: widget.task.description);
    _dueDate = widget.task.dueDate;
    _reminderDate = widget.task.reminderDate;
    _selectedColor =
        Color(int.parse("0xff${widget.task.colorCode.substring(1)}"));
    _isPinned = widget.task.isPinned;
    _loadCollaborators();
  }

  void _loadCollaborators() async {
    for (String collaboratorId in widget.task.collaboratorIds) {
      final doc =
          await _firestore.collection('users').doc(collaboratorId).get();
      if (doc.exists) {
        setState(() {
          _collaborators.add({
            'userName': doc['userName'],
            'email': doc['email'],
          });
        });
      }
    }
  }

  void _openColorPicker() {
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
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  void _saveTask() {
    if (_formKey.currentState?.validate() ?? false) {
      final updatedTask = widget.task.copyWith(
        title: _titleController.text,
        description: _descriptionController.text,
        dueDate: _dueDate,
        reminderDate: _reminderDate,
        isPinned: _isPinned,
        colorCode: '#${_selectedColor.value.toRadixString(16).substring(2)}',
      );
      context.read<TodoBloc>().add(EditTodoEvent(updatedTask));
      Navigator.pop(context);
    }
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
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('Edit Todo',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: Icon(
                      _isPinned ? Icons.push_pin : Icons.push_pin_outlined),
                  onPressed: () => setState(() => _isPinned = !_isPinned),
                ),
              ]),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) =>
                    value?.isEmpty == true ? 'Please enter a title' : null,
              ),
              TextFormField(
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
                      setState(() {});
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications),
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      final time = date != null
                          ? await showTimePicker(
                              context: context, initialTime: TimeOfDay.now())
                          : null;
                      if (date != null && time != null) {
                        _reminderDate = DateTime(date.year, date.month,
                            date.day, time.hour, time.minute);
                        setState(() {});
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.color_lens),
                    onPressed: _openColorPicker,
                  ),
                  IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        context.read<TodoBloc>().add(DeleteTodoEvent(
                            widget.task.id, widget.task.creatorId));
                      }),
                ],
              ),
              const SizedBox(height: 10),
              if (_collaborators.isNotEmpty)
                Column(
                  children: _collaborators
                      .map((collab) => ListTile(
                            leading: CircleAvatar(
                              child: Text(collab['userName']!.substring(0, 2)),
                            ),
                            title: Text(collab['userName']!),
                            subtitle: Text(collab['email']!),
                          ))
                      .toList(),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveTask,
                child: const Text('Save Todo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
