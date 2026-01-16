import 'package:flutter/material.dart';
import 'package:todo/models/todo.dart';

class TodoProgress extends StatelessWidget {
  final Todo todo;

  const TodoProgress({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    if (todo.progress <= 0) return const SizedBox.shrink();

    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: LinearProgressIndicator(
            value: todo.progress / 100,
            backgroundColor: colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
