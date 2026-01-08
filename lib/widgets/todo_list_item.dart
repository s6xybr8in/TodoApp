import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/models/importance.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/providers/todo_provider.dart';
import 'package:todo/theme/colors.dart';

class TodoListItem extends StatelessWidget {
  final Todo todo;
  final VoidCallback onTap;

  const TodoListItem({super.key, required this.todo, required this.onTap});

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
                      decoration: todo.isDone
                          ? TextDecoration.lineThrough
                          : null,
                      color: todo.isDone
                          ? TColors.doneTodoTextColor
                          : TColors.todoTextColor,
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  tooltip: '옵션',
                  icon: const Icon(Icons.more_horiz_rounded),
                  splashRadius: 20,
                  offset: const Offset(0, 8),
                  position: PopupMenuPosition.under,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onSelected: (value) async {
                    if (value == 'delete') {
                      await todoProvider.deleteTodo(todo);
                    } else if (value == 'cascade_delete') {
                      if (todo.repetitionId.isNotEmpty) {
                        // TODO: implement cascade delete for repetition series
                      }
                    } else if (value == 'toggle_star') {
                      await todoProvider.toggleStar(todo);
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    final bool hasSeries = todo.repetitionId.isNotEmpty;
                    final bool isStared = todo.isStared;
                    return <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: 'toggle_star',
                        child: Row(
                          children: [
                            Icon(
                              isStared
                                  ? Icons.star_rounded
                                  : Icons.star_border_rounded,
                              color: isStared
                                  ? Colors.amber
                                  : Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 12),
                            Text('즐겨찾기'),
                          ],
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete_outline_rounded,
                              color: Theme.of(context).colorScheme.error,
                            ),
                            const SizedBox(width: 12),
                            const Text('삭제'),
                          ],
                        ),
                      ),
                      if (hasSeries)
                        PopupMenuItem<String>(
                          value: 'cascade_delete',
                          child: Row(
                            children: const [
                              Icon(Icons.link_off_rounded),
                              SizedBox(width: 12),
                              Text('연관 삭제'),
                            ],
                          ),
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
                    style: const TextStyle(
                      fontSize: 12,
                      color: TColors.dateColor,
                    ),
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
