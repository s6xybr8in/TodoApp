import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/providers/todo_provider.dart';
import 'package:todo/screens/todo_detail_screen.dart';
import 'package:todo/widgets/todo_list_item.dart';


String getDateKey(DateTime date) {
  return date.toIso8601String().split('T')[0];
}


class DoneTodoList extends StatelessWidget {
  final DateTime? selectedDay;
  final Map<String, List> doneMapList;

  const DoneTodoList({
    super.key,
    required this.doneMapList,
    required this.selectedDay,
  });

  @override
  Widget build(BuildContext context) {
    final TodoProvider todoProvider = context.watch<TodoProvider>();
    final dateKey = getDateKey(selectedDay!);
    if (selectedDay == null ||
        !doneMapList.containsKey(dateKey) ||
        doneMapList[dateKey] == null) {
      return Center(
        child: Text('선택한 날짜에 완료된 투두가 없어요! ${selectedDay.toString()}'),
      );
    }

    final doneTodos =
        doneMapList[dateKey] ?? [];

    return ListView.builder(
      itemCount: doneTodos.length,
      itemBuilder: (context, index) {
        final todo = doneTodos[index];
        return TodoListItem(
          todo: todo,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => TodoDetailScreen(todo: todo,todoProvider: todoProvider,),
              ),
            );
          },
        );
      },
    );
  }
}
