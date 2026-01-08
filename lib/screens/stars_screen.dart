import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/providers/todo_provider.dart';
import 'package:todo/theme/app_decorations.dart';
import 'package:todo/widgets/star_list_item.dart';

class StarsScreen extends StatefulWidget {
  const StarsScreen({super.key});

  @override
  State<StarsScreen> createState() => _StarsScreenState();
}

class _StarsScreenState extends State<StarsScreen> {
  @override
  Widget build(BuildContext context) {
    final TodoProvider todoProvider = context.watch<TodoProvider>();
    List<Todo> stars = todoProvider.staredTodos;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '즐겨찾기',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        backgroundColor: const Color(0xFF7C3AED),
      ),
      body: stars.isEmpty
          ? const Center(child: Text('즐겨찾기 한 투두가 없어요!'))
          : ListView.builder(
              itemCount: stars.length,
              itemBuilder: (context, index) {
                final todo = stars[index];
                return StarListItem(todo: todo);
              },
            ),
    );
  }
}
