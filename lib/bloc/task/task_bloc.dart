import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:task_manager/bloc/task/task_event.dart';
import 'package:task_manager/models/task/task_model.dart';
import 'package:task_manager/bloc/task/task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final Box<Task> taskBox;

  TaskBloc({required this.taskBox}) : super(TaskInitial()) {
    on<LoadTasks>((event, emit) {
      emit(TaskLoading());
      final tasks = taskBox.values.toList();
      emit(TaskLoaded(tasks));
    });

    on<AddTask>((event, emit) async {
      await taskBox.add(event.task);
      add(LoadTasks());
    });

    on<EditTask>((event, emit) async {
      await taskBox.putAt(event.index, event.updatedTask);
      add(LoadTasks());
    });

    on<DeleteTask>((event, emit) async {
      await taskBox.deleteAt(event.index);
      add(LoadTasks());
    });
  }
}
