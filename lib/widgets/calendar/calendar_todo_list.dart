import 'package:flutter/material.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/screens/todo_detail_screen.dart';
import 'package:todo/widgets/todo_list_item.dart';

String getDateKey(DateTime date) {
  return date.toIso8601String().split('T')[0];
}

class CalendarTodoList extends StatelessWidget {
  final DateTime? selectedDay;
  final Map<String, List> todoMapList;
  final String emptyMessage;

  const CalendarTodoList({
    super.key,
    required this.todoMapList,
    required this.selectedDay,
    this.emptyMessage = '선택한 날짜에 투두가 없어요!',
  });

  @override
  Widget build(BuildContext context) {
    if (selectedDay == null) {
      return Center(child: Text(emptyMessage));
    }

    final dateKey = getDateKey(selectedDay!);
    
    // Check if the key exists and has items
    if (!todoMapList.containsKey(dateKey) || todoMapList[dateKey] == null || todoMapList[dateKey]!.isEmpty) {
      return Center(child: Text(emptyMessage));
    }

    // Use List.from to create a shallow copy to allow sorting, 
    // and cast to List<dynamic> first to handle potential type issues from the Map
    final todos = List<dynamic>.from(todoMapList[dateKey]!);
    
    // Sort todos (assuming Todo implements Comparable or similar logic exists)
    todos.sort();

    return ListView.builder(
      itemCount: todos.length,
      padding: const EdgeInsets.only(bottom: 20),
      itemBuilder: (context, index) {
        final todo = todos[index];
        // Ensure strictly typed for TodoListItem
        if (todo is! Todo) {
            return const SizedBox.shrink(); 
        }

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
