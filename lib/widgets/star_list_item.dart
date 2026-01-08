import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/models/importance.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/providers/todo_provider.dart';
import 'package:todo/screens/todo_detail_screen.dart';
import 'package:todo/theme/colors.dart';

class StarListItem extends StatelessWidget {
  final Todo todo;

  const StarListItem({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    final todoProvider = context.watch<TodoProvider>();
    final scheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TodoDetailScreen(
              title: todo.title,
              importance: todo.importance,
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _getImportanceColor(todo.importance).withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.star_rounded,
                        color: Colors.amber,
                        size: 24,
                      ),
                      onPressed: () async {
                        await todoProvider.toggleStar(todo);
                      },
                      splashRadius: 20,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 40,
                        minHeight: 40,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        todo.title,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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
                        } else if (value == 'toggle_star') {
                          await todoProvider.toggleStar(todo);
                        }
                      },
                      itemBuilder: (BuildContext context) {
                        return <PopupMenuEntry<String>>[
                          PopupMenuItem<String>(
                            value: 'toggle_star',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.star_outline_rounded,
                                  color: scheme.onSurfaceVariant,
                                ),
                                const SizedBox(width: 12),
                                const Text('찜 해제'),
                              ],
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.delete_outline_rounded,
                                  color: scheme.error,
                                ),
                                const SizedBox(width: 12),
                                const Text('삭제'),
                              ],
                            ),
                          ),
                        ];
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _getImportanceColor(
                            todo.importance,
                          ).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          todo.importance.name.toUpperCase(),
                          style: TextStyle(
                            fontSize: 11,
                            color: _getImportanceColor(todo.importance),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${todo.startDate.toString().substring(5, 10)} ~ ${todo.endDate.toString().substring(5, 10)}',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
