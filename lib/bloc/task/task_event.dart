import 'package:equatable/equatable.dart';
import 'package:task_manager/models/task/task_model.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class LoadTasks extends TaskEvent {}

class AddTask extends TaskEvent {
  final Task task;

  const AddTask(this.task);

  @override
  List<Object?> get props => [task];
}

class EditTask extends TaskEvent {
  final int index;
  final Task updatedTask;

  const EditTask({required this.index, required this.updatedTask});

  @override
  List<Object?> get props => [index, updatedTask];
}

class DeleteTask extends TaskEvent {
  final int index;

  const DeleteTask(this.index);

  @override
  List<Object?> get props => [index];
}
