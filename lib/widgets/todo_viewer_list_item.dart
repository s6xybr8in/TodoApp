import 'package:flutter/material.dart';
import 'package:todo/locator.dart';
import 'package:todo/models/importance.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/repositories/star_repository.dart';
import 'package:todo/repositories/todo_repository.dart';
import 'package:todo/screens/todo_detail_screen.dart';
import 'package:todo/theme/colors.dart';

class TodoViewerListItem extends StatelessWidget {
  final Todo todo;
  final TodoRepository _todoRepository = locator<TodoRepository>();
  final StarRepository _starRepository = locator<StarRepository>();

  TodoViewerListItem({
    super.key,
    required this.todo,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to detail screen to create a new Todo
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TodoDetailScreen(todo: _starRepository.makeTodo(todo.title, todo.importance), isNew: true),
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
              color: TColors.shadowColor.withOpacity(0.5),
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
              onPressed: () {
                _todoRepository.toggleStar(todo);
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
