import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/screens/home_screen.dart';

void main() async {
  // Flutter 앱이 시작되기 전에 Hive를 초기화합니다.
  await Hive.initFlutter();

  // Hive 어댑터를 등록합니다.
  Hive.registerAdapter(TodoAdapter());
  Hive.registerAdapter(ImportanceAdapter());

  // 'todos'라는 이름의 Box를 엽니다.
  await Hive.openBox<Todo>('todos');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TodoApp',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}



