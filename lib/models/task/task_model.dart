// ignore_for_file: constant_identifier_names
import 'package:hive/hive.dart';
part 'task_model.g.dart';

@HiveType(typeId: 0)
enum Priority {
  @HiveField(0)
  High,
  @HiveField(1)
  Medium,
  @HiveField(2)
  Low,
}

@HiveType(typeId: 1)
class Task extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  int timerSeconds;

  @HiveField(2)
  Priority priority;

  @HiveField(3)
  bool isCompleted;

  @HiveField(4)
  String? description;

  Task({
    required this.name,
    required this.timerSeconds,
    required this.priority,
    this.isCompleted = false,
    required this.description,
  });
}
