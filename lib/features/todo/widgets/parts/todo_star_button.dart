import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/providers/todo_provider.dart';

class TodoStarButton extends StatelessWidget {
  final Todo todo;

  const TodoStarButton({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return IconButton(
      onPressed: () async {
        await context.read<TodoProvider>().toggleStar(todo);
      },
      icon: Icon(
        todo.isStared ? Icons.star_rounded : Icons.star_border_rounded,
        color: todo.isStared ? Colors.amber : colorScheme.onSurfaceVariant,
      ),
    );
  }
}
