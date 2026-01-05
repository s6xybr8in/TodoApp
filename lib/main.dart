import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo/locator.dart';
import 'package:todo/models/importance.dart';
import 'package:todo/models/star.dart';
import '/models/daily.dart';
import '/models/todo.dart';
import '/screens/main_screen.dart';
int selectedIndex = 0;

void main() async {
  // Flutter 앱이 시작되기 전에 Hive를 초기화합니다.
  await Hive.initFlutter();

  // Hive 어댑터를 등록합니다.

  Hive.registerAdapter(TodoAdapter());
  Hive.registerAdapter(ImportanceAdapter());
  Hive.registerAdapter(DailyAdapter());
  Hive.registerAdapter(StarAdapter());

  // 'todos'라는 이름의 Box를 엽니다.
  await Hive.openBox<Todo>('todos');
  await Hive.openBox<Daily>('dailies'); 
  await Hive.openBox<Star>('stars');

  setupLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo App',
      theme: ThemeData(
        fontFamily: 'Pretendard',
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4F46E5), // Primary color from SVG
          primary: const Color(0xFF4F46E5), // Indigo
          secondary: const Color(0xFF7C3AED), // Violet
          surface: Colors.white
          //background: Colors.white,
          // Rest of the colors can be derived or set explicitly
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF4F46E5),
          foregroundColor: Colors.white, // For title and icons
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF4F46E5),
          foregroundColor: Colors.white,
        ),
      ),
      home: const MainScreen(),
    );
  }
}



