import 'package:flutter/material.dart';
import 'package:todo/models/daily.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/screens/todo_detail_screen.dart';
import 'package:todo/widgets/todo_list_item.dart';

class DoneTodoList extends StatelessWidget {
  final Daily? dailyForSelectedDay;

  const DoneTodoList({
    super.key,
    required this.dailyForSelectedDay,
  });

  @override
  Widget build(BuildContext context) {
    if (dailyForSelectedDay == null ||
        !dailyForSelectedDay!.isInBox ||
        dailyForSelectedDay!.content == null) {
      return const Center(
        child: Text('선택한 날짜에 완료된 투두가 없어요!'),
      );
    }

    final doneTodos =
        dailyForSelectedDay!.content!.where((todo) => todo.isDone).toList();

    if (doneTodos.isEmpty) {
      return const Center(
        child: Text('선택한 날짜에 완료된 투두가 없어요!'),
      );
    }

    return ListView.builder(
      itemCount: doneTodos.length,
      itemBuilder: (context, index) {
        final todo = doneTodos[index];
        return TodoListItem(
          todo: todo,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => TodoDetailScreen(todo: todo),
              ),
            );
          },
        );
      },
    );
  }
}
