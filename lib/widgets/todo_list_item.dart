import 'package:flutter/material.dart';
import 'package:todoapp/models/todo.dart';

class TodoListItem extends StatelessWidget {
  final Todo todo;
  final VoidCallback onTap;
  final ValueChanged<bool?> onCheckboxChanged;

  const TodoListItem({
    super.key,
    required this.todo,
    required this.onTap,
    required this.onCheckboxChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        onTap: onTap,
        leading: Checkbox(
          value: todo.isCompleted,
          onChanged: onCheckboxChanged,
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
            color: todo.isCompleted ? Colors.grey : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value: todo.progress / 100,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                _getImportanceColor(todo.importance).withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Chip(
                  label: Text(
                    todo.importance.name,
                    style: const TextStyle(fontSize: 12),
                  ),
                  backgroundColor: _getImportanceColor(todo.importance).withOpacity(0.2),
                  padding: EdgeInsets.zero,
                ),
                const Spacer(),
                Text(
                  '${todo.startDate.toString().substring(5, 10)} ~ ${todo.endDate.toString().substring(5, 10)}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }

  Color _getImportanceColor(Importance importance) {
    switch (importance) {
      case Importance.high:
        return Colors.redAccent;
      case Importance.medium:
        return Colors.orangeAccent;
      case Importance.low:
        return Colors.blueAccent;
      default:
        return Colors.grey;
    }
  }
}
