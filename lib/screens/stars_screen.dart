import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo/locator.dart';
import 'package:todo/models/star.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/repositories/star_repository.dart';
import 'package:todo/screens/todo_detail_screen.dart';
import 'package:todo/theme/app_decorations.dart';
import 'package:todo/widgets/todo_list_item.dart';
import 'package:todo/widgets/todo_viewer_list_item.dart';

class StarsScreen extends StatefulWidget {
  const StarsScreen({super.key});

  @override
  State<StarsScreen> createState() => _StarsScreenState();
}

class _StarsScreenState extends State<StarsScreen> {
  @override
  Widget build(BuildContext context) {
    final Box<Star> starBox = Hive.box<Star>('stars');
    final Box<Todo> todoBox = Hive.box<Todo>('todos');
    final StarRepository _starRepository = locator<StarRepository>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stars', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        flexibleSpace: Container(
          decoration: kAppBarDecoration,
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: starBox.listenable(),
        builder: (context, Box<Star> stars, _) {
          return ValueListenableBuilder(
            valueListenable: todoBox.listenable(),
            builder: (context, Box<Todo> todos, __) {
              final starredTodos = starBox.values
                  .map((star) => todos.get(star.id))
                  .where((todo) => todo != null)
                  .cast<Todo>()
                  .toList();
              
              starredTodos.sort();

              if (starredTodos.isEmpty) {
                return const Center(
                  child: Text('찜 한 투두가 없어요!'),
                );
              }

              return ListView.builder(
                itemCount: starredTodos.length,
                itemBuilder: (context, index) {
                  final todo = starredTodos[index];
                  return TodoViewerListItem(
                    todo: todo,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}


