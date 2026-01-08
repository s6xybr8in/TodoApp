import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todo/models/importance.dart';
import 'package:todo/providers/todo_provider.dart';
import 'package:todo/repositories/todo_repository.dart';
import 'package:todo/theme/app_theme.dart';
import '/models/todo.dart';
import '/screens/main_screen.dart';

int selectedIndex = 0;

void main() async {
  // Flutter 앱이 시작되기 전에 Hive를 초기화합니다.
  await Hive.initFlutter();

  // Hive 어댑터를 등록합니다.

  Hive.registerAdapter(TodoAdapter());
  Hive.registerAdapter(ImportanceAdapter());

  // 'todos'라는 이름의 Box를 엽니다.
  await Hive.openBox<Todo>('todos');

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => TodoRepository()),
        ChangeNotifierProvider(
          create: (context) => TodoProvider(context.read<TodoRepository>()),
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
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const MainScreen(),
    );
  }
}
