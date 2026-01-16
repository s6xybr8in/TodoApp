import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todo/models/importance.dart';
import 'package:todo/models/repetition.dart';
import 'package:todo/models/todo_status.dart';
import 'package:todo/models/todo_time_log.dart';
import 'package:todo/providers/repetition_provider.dart';
import 'package:todo/providers/todo_provider.dart';
import 'package:todo/providers/todo_time_log_provider.dart';
import 'package:todo/repositories/repetition_repository.dart';
import 'package:todo/repositories/todo_repository.dart';
import 'package:todo/repositories/todo_time_log_repository.dart';
import 'package:todo/theme/theme.dart';

import '/features/main/screens/main_screen.dart';
import '/models/todo.dart';

int selectedIndex = 0;

void main() async {
  // Flutter 앱이 시작되기 전에 Hive를 초기화합니다.
  await Hive.initFlutter();

  // Hive 어댑터를 등록합니다.

  Hive.registerAdapter(TodoAdapter());
  Hive.registerAdapter(RepetitionAdapter());
  Hive.registerAdapter(RepeatTypeAdapter());
  Hive.registerAdapter(TodoStatusAdapter());
  Hive.registerAdapter(ImportanceAdapter());
  Hive.registerAdapter(TodoTimeLogAdapter());

  // 'todos'라는 이름의 Box를 엽니다.
  await Hive.openBox<Todo>('todos');
  await Hive.openBox<Repetition>('repetitions');
  await Hive.openBox<TodoTimeLog>('todo_time_logs');

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => TodoRepository()),
        Provider(create: (_) => RepetitionRepository()),
        Provider(create: (_) => TodoTimeLogRepository()),
        ChangeNotifierProvider(
          create: (context) => TodoProvider(context.read<TodoRepository>()),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              RepetitionProvider(context.read<RepetitionRepository>()),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              TodoTimeLogProvider(context.read<TodoTimeLogRepository>()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo App',
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const MainScreen(),
    );
  }
}
