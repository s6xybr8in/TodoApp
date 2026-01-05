import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo/locator.dart';
import 'package:todo/models/importance.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/repositories/todo_repository.dart';
import 'package:todo/screens/todo_detail_screen.dart';
import 'package:todo/theme/app_decorations.dart';
import 'package:todo/widgets/todo_list_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TodoRepository _todoRepository = locator<TodoRepository>();

  @override
  Widget build(BuildContext context) {
    // Hive Box를 가져옵니다.
    final Box<Todo> todoBox = Hive.box<Todo>('todos');

    return Scaffold(

      appBar: AppBar(
        title: const Text('Todo App', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0, // for a flatter look
        flexibleSpace: Container(
          decoration: kAppBarDecoration,
        ),
      ),
      // ValueListenableBuilder를 사용하여 Hive Box의 변경사항을 실시간으로 감지합니다.
      body: ValueListenableBuilder(
        valueListenable: todoBox.listenable(),
        builder: (context, Box<Todo> box, _) {
          // Hive Box에서 isDone이 false인 Todo 목록을 가져옵니다.
          final todos = box.values.where((todo) => !todo.isDone).toList().cast<Todo>();
          todos.sort();

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
                      builder: (context) => TodoDetailScreen(todo: todo, isNew: false),
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
            MaterialPageRoute(builder: (context) => TodoDetailScreen(todo: _todoRepository.makeTodo('', Importance.medium), isNew: true)),
          );
        },
        tooltip: '새로운 투두 추가',
        child: const Icon(Icons.add),
      ),
    );
  }
}
