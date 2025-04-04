import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_manager/bloc/task/task_bloc.dart';
import 'package:task_manager/bloc/task/task_event.dart';
import 'package:task_manager/config/routes/router.dart';
import 'package:task_manager/models/task/task_model.dart';
import 'package:task_manager/repository/auth/login_mock_api_repository.dart';
import 'package:task_manager/repository/auth/login_repository.dart';

final GetIt getIt = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(PriorityAdapter());

  final taskBox = await Hive.openBox<Task>('tasksBox');

  // Register Hive box & dependencies
  serviceLocator(taskBox);

  runApp(const MyApp());
}

void serviceLocator(Box<Task> taskBox) {
  getIt.registerLazySingleton<LoginRepository>(() => LoginMockApiRepository());
  getIt.registerSingleton<Box<Task>>(taskBox);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TaskBloc>(
          create: (context) => TaskBloc(taskBox: getIt<Box<Task>>())..add(LoadTasks()),
        ),
      ],
      child: MaterialApp.router(
        title: 'Task Manager',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light().copyWith(
          primaryColor: Colors.deepPurpleAccent,
          scaffoldBackgroundColor: Colors.white,
          textTheme: const TextTheme(bodyLarge: TextStyle(color: Colors.black)),
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurpleAccent,
          ).copyWith(surface: Colors.white),
        ),
        routerConfig: router,
      ),
    );
  }
}
