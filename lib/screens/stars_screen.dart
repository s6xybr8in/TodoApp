import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/models/star.dart';
import 'package:todo/providers/star_provider.dart';
import 'package:todo/providers/todo_provider.dart';
import 'package:todo/theme/app_decorations.dart';
import 'package:todo/widgets/star_list_item.dart';

class StarsScreen extends StatefulWidget {
  const StarsScreen({super.key});

  @override
  State<StarsScreen> createState() => _StarsScreenState();
}

class _StarsScreenState extends State<StarsScreen> {
  @override
  Widget build(BuildContext context) {
    final StarProvider starProvider = context.watch<StarProvider>();
    final TodoProvider todoProvider = context.watch<TodoProvider>();
    List<Star> stars = starProvider.stars;
    print('StarsScreen rebuild with ${stars.length} starred items');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stars', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        flexibleSpace: Container(
          decoration: kAppBarDecoration,
        ),
      ),
      body:  stars.isEmpty ?
                const Center(
                  child: Text('찜 한 투두가 없어요!'),
                )
                :
              ListView.builder(
                itemCount: stars.length,
                itemBuilder: (context, index) {
                  final todo = todoProvider.getTodo(stars[index].id);
                  return StarListItem(
                    todo: todo!,
                  );
                },
              ),
    );
  }
}


