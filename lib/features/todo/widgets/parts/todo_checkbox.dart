import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/models/todo_status.dart';
import 'package:todo/providers/todo_provider.dart';

class TodoCheckbox extends StatelessWidget {
  final Todo todo;

  const TodoCheckbox({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: todo.status != TodoStatus.active,
      onChanged: (bool? value) async {
        final todoProvider = context.read<TodoProvider>();
        if (value == true) {
          // 체크되지 않은 상태 -> 체크됨 (상태 선택)
          final TodoStatus? selectedStatus = await showDialog<TodoStatus>(
            context: context,
            builder: (BuildContext context) {
              return SimpleDialog(
                title: const Text('상태 선택'),
                children: [
                  SimpleDialogOption(
                    onPressed: () {
                      Navigator.pop(context, TodoStatus.done);
                    },
                    child: const Text('완료'),
                  ),
                  SimpleDialogOption(
                    onPressed: () {
                      Navigator.pop(context, TodoStatus.deferred);
                    },
                    child: const Text('미루기'),
                  ),
                  SimpleDialogOption(
                    onPressed: () {
                      Navigator.pop(context, TodoStatus.failed);
                    },
                    child: const Text('못함'),
                  ),
                  SimpleDialogOption(
                    onPressed: () {
                      Navigator.pop(context, TodoStatus.insufficient);
                    },
                    child: const Text('부족함'),
                  ),
                ],
              );
            },
          );

          if (selectedStatus != null) {
            todo.status = selectedStatus;
            await todoProvider.updateTodo(todo);
          }
        } else {
          // 이미 체크된 상태 -> 체크 해제 (다시 Active)
          todo.status = TodoStatus.active;
          await todoProvider.updateTodo(todo);
        }
      },
    );
  }
}
