import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/features/todo/widgets/quick_add_todo_sheet.dart';
import 'package:todo/features/todo/widgets/todo_list_item.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/providers/todo_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final TodoProvider todoProvider = context.watch<TodoProvider>();
    List<Todo> todos = todoProvider.activeRootTodos;
    return Scaffold(
      appBar: AppBar(title: const Text('오늘의 할 일')),
      body: todos.isEmpty
          ? const Center(child: Text('투두가 없어요! 새로운 투두를 추가해보세요.'))
          : ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                return TodoListItem(todo: todo);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 기존 페이지 이동 대신 ModalBottomSheet 표시
          showModalBottomSheet(
            context: context,
            isScrollControlled: true, // 키보드 올라왔을 때 화면 전체 사용
            backgroundColor: Colors.transparent, // 모서리 둥글게 하기 위해 배경 투명
            builder: (context) => const QuickAddTodoSheet(),
          );
        },
        tooltip: '새로운 투두 추가',
        child: const Icon(Icons.add),
      ),
    );
  }
}
