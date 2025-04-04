import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/bloc/task/task_bloc.dart';
import 'package:task_manager/bloc/task/task_event.dart';
import 'package:task_manager/models/task/task_model.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _timerController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  Priority _selectedPriority = Priority.Low;

  void _submitTask() {
    if (_formKey.currentState!.validate()) {
      final taskName = _nameController.text.trim();
      final description = _descController.text.trim();
      final durationInMinutes = int.tryParse(_timerController.text.trim()) ?? 0;

      final newTask = Task(
        name: taskName,
        timerSeconds: durationInMinutes * 60,
        priority: _selectedPriority,
        description: description.isEmpty ? null : description,
      );

      context.read<TaskBloc>().add(AddTask(newTask));
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _timerController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurpleAccent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Task Name'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Please enter a task name'
                            : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _timerController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Time (in minutes)',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Please enter time';
                  final parsed = int.tryParse(value);
                  if (parsed == null) return 'Enter a valid number';
                  if (parsed <= 0) return 'Time must be greater than 0';
                  if (parsed > 180) return 'Task time cannot exceed 3 hours';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<Priority>(
                value: _selectedPriority,
                decoration: const InputDecoration(labelText: 'Priority'),
                items:
                    Priority.values.map((priority) {
                      return DropdownMenuItem(
                        value: priority,
                        child: Text(
                          priority.name,
                          style: TextStyle(color: Colors.black),
                        ),
                      );
                    }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedPriority = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitTask,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  'Add Task',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
