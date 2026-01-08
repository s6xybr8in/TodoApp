import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/models/importance.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/providers/todo_provider.dart';
import 'package:todo/screens/todo_detail_screen.dart';
import 'package:todo/theme/colors.dart';

class StarListItem extends StatelessWidget {
  final Todo todo;

  const StarListItem({
    super.key,
    required this.todo,
  });

  @override
  Widget build(BuildContext context) {
    final TodoProvider todoProvider = context.watch<TodoProvider>();
    
    return GestureDetector(
      onTap: () {
        // Navigate to detail screen to create a new Todo
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TodoDetailScreen(todoProvider: todoProvider, title: todo.title, importance: todo.importance),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: TColors.backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: TColors.borderColor),
          boxShadow: [
            BoxShadow(
              color: TColors.shadowColor,
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            IconButton(
              icon: Icon(
                todo.isStared ? Icons.star : Icons.star_border,
                color: todo.isStared ? Colors.amber : Colors.grey,
              ),
              onPressed: () async{
                context.read<TodoProvider>().toggleStar(todo);
              },
            ),
            Expanded(
              child: Text(
                todo.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Chip(
              label: Text(
                todo.importance.name.toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  color: _getImportanceColor(todo.importance),
                  fontWeight: FontWeight.bold,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
      ),
    );
  }

  Color _getImportanceColor(Importance importance) {
    switch (importance) {
      case Importance.high:
        return TColors.highImportanceColor;
      case Importance.medium:
        return TColors.mediumImportanceColor;
      case Importance.low:
        return TColors.lowImportanceColor;
    }
  }
}
