import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:go_router/go_router.dart';
import 'package:task_manager/bloc/task/task_bloc.dart';
import 'package:task_manager/bloc/task/task_event.dart';
import 'package:task_manager/bloc/task/task_state.dart';
import 'package:task_manager/config/routes/routes_name.dart';
import 'package:task_manager/models/task/task_model.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final Map<int, CountdownTimerController> _controllers = {};
  final Map<int, int> _endTimes = {};
  final Map<int, bool> _isPaused = {};

  @override
  void initState() {
    super.initState();
    context.read<TaskBloc>().add(LoadTasks());
  }

  void _initController(Task task, int index) {
    final endTime =
        DateTime.now().millisecondsSinceEpoch + (task.timerSeconds * 1000);
    _endTimes[index] = endTime;
    _controllers[index] = CountdownTimerController(
      endTime: endTime,
      onEnd: () {},
    );
    _isPaused[index] = false;
  }

  void _pauseTask(Task task, int index) {
    _controllers[index]?.dispose();
    final now = DateTime.now().millisecondsSinceEpoch;
    final remainingMillis = _endTimes[index]! - now;
    final roundedSeconds = ((remainingMillis / 1000) / 60).ceil() * 60;

    task.timerSeconds = roundedSeconds;
    context.read<TaskBloc>().add(EditTask(index: index, updatedTask: task));
    _isPaused[index] = true;
    setState(() {});
  }

  void _resumeTask(Task task, int index) {
    final newEndTime =
        DateTime.now().millisecondsSinceEpoch + (task.timerSeconds * 1000);
    _endTimes[index] = newEndTime;
    _controllers[index] = CountdownTimerController(
      endTime: newEndTime,
      onEnd: () {},
    );
    _isPaused[index] = false;
    setState(() {});
  }

  void _stopTask(Task task) {
    task.isCompleted = true;
    task.save();
    context.read<TaskBloc>().add(LoadTasks());
  }

  @override
  void dispose() {
    super.dispose();
    for (var controller in _controllers.values) {
      controller.dispose();
    }
  }

  Color _getPriorityColor(Priority priority) {
    switch (priority) {
      case Priority.High:
        return Colors.red;
      case Priority.Medium:
        return Colors.orange;
      case Priority.Low:
        return Colors.green;
    }
  }

  Color _getCardColor(bool isCompleted) {
    return isCompleted ? Colors.white : Colors.blueGrey.shade200;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurpleAccent,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.goNamed(RoutesName.addTaskScreen),
        backgroundColor: Colors.deepPurpleAccent,
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TaskLoaded) {
            final tasks = state.tasks;

            if (tasks.isEmpty) {
              return const Center(child: Text('No tasks available.'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                _controllers[index] ??= CountdownTimerController(
                  endTime:
                      DateTime.now().millisecondsSinceEpoch +
                      task.timerSeconds * 1000,
                  onEnd: () {},
                );
                _endTimes[index] ??=
                    DateTime.now().millisecondsSinceEpoch +
                    task.timerSeconds * 1000;

                return InkWell(
                  onTap: (){
                    context.goNamed(RoutesName.taskDetail, extra: task);
                  },
                  child: Card(
                    color: _getCardColor(task.isCompleted),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                margin: const EdgeInsets.only(right: 12),
                                decoration: BoxDecoration(
                                  color: _getPriorityColor(task.priority),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  task.name,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          if (task.description?.isNotEmpty ?? false)
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Text(
                                task.description!,
                                style: const TextStyle(color: Colors.black54),
                              ),
                            ),
                          const SizedBox(height: 10),
                          if (!task.isCompleted)
                            CountdownTimer(
                              controller: _controllers[index],
                              endTime: _endTimes[index]!,
                              textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              ElevatedButton.icon(
                                onPressed:
                                    task.isCompleted || _isPaused[index] == true
                                        ? null
                                        : () => _pauseTask(task, index),
                                icon: const Icon(Icons.pause),
                                label: const Text('Pause'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.amber,
                                ),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton.icon(
                                onPressed:
                                    task.isCompleted || _isPaused[index] == false
                                        ? null
                                        : () => _resumeTask(task, index),
                                icon: const Icon(Icons.play_arrow),
                                label: const Text('Resume'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton.icon(
                                onPressed:
                                    task.isCompleted
                                        ? null
                                        : () => _stopTask(task),
                                icon: const Icon(Icons.stop),
                                label: const Text('Stop'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (state is TaskError) {
            return Center(child: Text(state.message));
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
