import 'package:flutter/material.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/models/todo_status.dart';

class TodoTitle extends StatelessWidget {
  final Todo todo;

  const TodoTitle({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isDone = todo.status != TodoStatus.active;

    return Text(
      todo.title,
      style: textTheme.bodyLarge?.copyWith(
        decoration: isDone ? TextDecoration.lineThrough : null,
        color: isDone ? textTheme.bodySmall?.color : textTheme.bodyLarge?.color,
      ),
    );
  }
}
