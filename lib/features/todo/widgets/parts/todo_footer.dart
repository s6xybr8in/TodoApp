import 'package:flutter/material.dart';
import 'package:todo/models/todo.dart';

class TodoFooter extends StatelessWidget {
  final Todo todo;

  const TodoFooter({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Chip(
            label: Text(
              todo.importance.name.toUpperCase(),
              style: textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            visualDensity: VisualDensity.compact,
          ),
          const Spacer(),
          Text(
            '${todo.startDate.toString().substring(5, 10)} ~ ${todo.endDate.toString().substring(5, 10)}',
            style: textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
