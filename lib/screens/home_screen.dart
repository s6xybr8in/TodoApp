import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
//import 'package:todo/models/daily.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/screens/todo_detail_screen.dart';
import 'package:todo/widgets/todo_list_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    // Hive Box를 가져옵니다.
    final Box<Todo> todoBox = Hive.box<Todo>('todos');
    //final Box<Daily> dailyBox = Hive.box<Daily>('dailies');

    return Scaffold(

      appBar: AppBar(
        title: const Text('Todo App', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0, // for a flatter look
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF4F46E5), // indigo
                Color(0xFF7C3AED), // violet
                Color(0xFF2563EB), // blue
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      // ValueListenableBuilder를 사용하여 Hive Box의 변경사항을 실시간으로 감지합니다.
      body: ValueListenableBuilder(
        valueListenable: todoBox.listenable(),
        builder: (context, Box<Todo> box, _) {
          // Hive Box에서 isDone이 false인 Todo 목록을 가져옵니다.
          final todos = box.values.where((todo) => !todo.isDone).toList().cast<Todo>();

          // 중요도(내림차순), 그다음 제목(오름차순)으로 목록을 정렬합니다.
          todos.sort((a, b) {
            // 중요도를 기준으로 비교합니다. (high > medium > low)
            final importanceCompare = b.importance.index.compareTo(a.importance.index);
            if (importanceCompare != 0) {
              return importanceCompare;
            }
            // 중요도가 같으면 제목을 기준으로 오름차순으로 비교합니다.
            return a.title.compareTo(b.title);
          });

          if (todos.isEmpty) {
            return const Center(
              child: Text('완료할 투두가 없어요!'),
            );
          }

          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return TodoListItem(
                todo: todo,
                onTap: () {
                  // 수정 화면으로 이동
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => TodoDetailScreen(todo: todo),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 추가 화면으로 이동
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const TodoDetailScreen()),
          );
        },
        tooltip: '새로운 투두 추가',
        child: const Icon(Icons.add),
      ),
    );
  }
}
