import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/models/importance.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/providers/star_provider.dart';
import 'package:todo/providers/todo_provider.dart';
import 'package:todo/theme/colors.dart';

class TodoListItem extends StatelessWidget {
  final Todo todo;
  final VoidCallback onTap;

  const TodoListItem({
    super.key,
    required this.todo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final TodoProvider todoProvider = context.watch<TodoProvider>();
    return GestureDetector(
      onTap: onTap,
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
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Checkbox(
                  value: todo.isDone,
                  onChanged: (_) async {
                    await todoProvider.toggleDone(todo);
                  },
                  activeColor: _getImportanceColor(todo.importance),
                ),
                Expanded(
                  child: Text(
                    todo.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      decoration:
                          todo.isDone ? TextDecoration.lineThrough : null,
                      color: todo.isDone
                          ? TColors.doneTodoTextColor
                          : TColors.todoTextColor,
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) async{
                    if (value == 'delete') {
                      await todoProvider.deleteTodo(todo);
                    } else if (value == 'cascade_delete') {
                      if (!todo.repetitionId.isEmpty) {
                        // todo.delete_cascade();
                      }
                    } else if (value == 'toggle_star'){
                      await todoProvider.toggleStar(todo);
                      if (todo.isStared) {
                        context.read<StarProvider>().addStar(todo.id);
                      }else{
                        context.read<StarProvider>().deletebyID(todo.id);
                      }
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      const PopupMenuItem<String>(
                        value: 'delete',
                        child: Text('삭제'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'cascade_delete',
                        child: Text('연관 삭제'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'toggle_star',
                        child: Text('찜'),
                      ),
                    ];
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (todo.progress > 0) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: LinearProgressIndicator(
                  value: todo.progress / 100,
                  backgroundColor: TColors.progressIndicatorBackgroundColor,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getImportanceColor(todo.importance),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Chip(
                    label: Text(
                      todo.importance.name.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        color: _getImportanceColor(todo.importance),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // backgroundColor: _getImportanceColor(todo.importance),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    visualDensity: VisualDensity.compact,
                  ),
                  const Spacer(),
                  Text(
                    '${todo.startDate.toString().substring(5, 10)} ~ ${todo.endDate.toString().substring(5, 10)}',
                    style: const TextStyle(fontSize: 12, color: TColors.dateColor),
                  ),
                ],
              ),
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