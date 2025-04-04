// ignore_for_file: unused_element
import 'package:go_router/go_router.dart';
import 'package:task_manager/config/routes/routes_name.dart';
import 'package:task_manager/ui/auth/login_screen.dart';
import 'package:task_manager/ui/splash/splash_screen.dart';
import 'package:task_manager/ui/tasks/add-task/add_task_screen.dart';
import 'package:task_manager/ui/tasks/task-detail/task_detail.dart';
import 'package:task_manager/ui/tasks/tasks_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: "/",
  routes: [
    GoRoute(
      name: RoutesName.splashScreen,
      path: "/",
      builder: ((context, state) => const SplashScreen()),
    ),
    GoRoute(
      name: RoutesName.loginScreen,
      path: "/login",
      builder: ((context, state) => const LoginScreen()),
    ),
    GoRoute(
      name: RoutesName.taskScreen,
      path: "/tasks",
      builder: ((context, state) => const TasksScreen()),
      routes: [
        GoRoute(
          name: RoutesName.addTaskScreen,
          path: "/tasks/add-task",
          builder: ((context, state) => const AddTaskScreen()),
        ),
        GoRoute(
          name: RoutesName.taskDetail,
          path: "/tasks/task-detail",
          builder: ((context, state) => const TaskDetail()),
        ),
      ],
    ),
  ],
);
