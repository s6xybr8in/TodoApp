import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/features/todo/screens/todo_detail_screen.dart';
import 'package:todo/features/todo/widgets/parts/todo_checkbox.dart';
import 'package:todo/features/todo/widgets/parts/todo_expand_button.dart';
import 'package:todo/features/todo/widgets/parts/todo_footer.dart';
import 'package:todo/features/todo/widgets/parts/todo_progress.dart';
import 'package:todo/features/todo/widgets/parts/todo_star_button.dart';
import 'package:todo/features/todo/widgets/parts/todo_title.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/providers/todo_provider.dart';

class TodoListItem extends StatefulWidget {
  final Todo todo;

  const TodoListItem({super.key, required this.todo});

  @override
  State<TodoListItem> createState() => _TodoListItemState();
}

void onTap(BuildContext context, Todo todo) => Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => TodoDetailScreen(todo: todo)));

class _TodoListItemState extends State<TodoListItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    // 변경 사항을 감지하기 위해 watch 사용
    final todoProvider = context.watch<TodoProvider>();
    List<Todo> children = [];
    if (widget.todo.childrenIds.isNotEmpty) {
      children = widget.todo.childrenIds
          .map((id) => todoProvider.getTodo(id))
          .whereType<Todo>()
          .toList();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => onTap(context, widget.todo),
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      TodoCheckbox(todo: widget.todo),
                      Expanded(child: TodoTitle(todo: widget.todo)),
                      if (children.isNotEmpty)
                        TodoExpandButton(
                          isExpanded: _isExpanded,
                          onPressed: () {
                            setState(() {
                              _isExpanded = !_isExpanded;
                            });
                          },
                        ),
                      TodoStarButton(todo: widget.todo),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TodoProgress(todo: widget.todo),
                  TodoFooter(todo: widget.todo),
                ],
              ),
            ),
          ),
        ),
        if (_isExpanded && children.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 32.0),
            child: Column(
              children: children
                  .map((childTodo) => TodoListItem(todo: childTodo))
                  .toList(),
            ),
          ),
      ],
    );
  }
}
