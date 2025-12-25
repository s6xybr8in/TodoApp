import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('나의 투두리스트'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      // ValueListenableBuilder를 사용하여 Hive Box의 변경사항을 실시간으로 감지합니다.
      body: ValueListenableBuilder(
        valueListenable: todoBox.listenable(),
        builder: (context, Box<Todo> box, _) {
          if (box.values.isEmpty) {
            return const Center(
              child: Text('아직 추가된 투두가 없어요!'),
            );
          }
          // Hive Box에서 Todo 목록을 가져옵니다.
          final todos = box.values.toList().cast<Todo>();

          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return TodoListItem(
                todo: todo,
                onCheckboxChanged: (bool? value) {
                  // 체크박스 상태가 변경되면 Hive에 저장된 객체를 업데이트합니다.
                  todo.isCompleted = value ?? false;
                  todo.save();
                },
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
