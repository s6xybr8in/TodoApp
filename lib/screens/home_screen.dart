import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/providers/todo_provider.dart';
import 'package:todo/screens/todo_detail_screen.dart';
import 'package:todo/theme/app_decorations.dart';
import 'package:todo/widgets/todo_list_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final TodoProvider todoProvider = context.watch<TodoProvider>();
    List<Todo> todos = todoProvider.todos.where((todo) => !todo.isDone).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo App', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0, // for a flatter look
        flexibleSpace: Container(
          decoration: kAppBarDecoration,
        ),
      ),
      body:  todos.isEmpty
          ? const Center(
              child: Text('투두가 없어요! 새로운 투두를 추가해보세요.'),
            ) :
            ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return TodoListItem(
                todo: todo,
                onTap: () {
                  // 수정 화면으로 이동
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => TodoDetailScreen(todo: todo, todoProvider: todoProvider),
                    ),
                  );
                },
              );
            },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 추가 화면으로 이동
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => TodoDetailScreen(todoProvider: todoProvider)),
          );
        },
        tooltip: '새로운 투두 추가',
        child: const Icon(Icons.add),
      ),
    );
  }
}
