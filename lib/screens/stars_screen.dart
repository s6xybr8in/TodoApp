import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo/models/star.dart';
import 'package:todo/repositories/star_repository.dart';
import 'package:todo/screens/todo_detail_screen.dart';
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
    // Hive Box를 가져옵니다.
    final Box<Star> starBox = Hive.box<Star>('stars');

    return Scaffold(

      appBar: AppBar(
        title: const Text('Stars', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0, // for a flatter look
        flexibleSpace: Container(
          decoration: kAppBarDecoration,
        ),
      ),
      // ValueListenableBuilder를 사용하여 Hive Box의 변경사항을 실시간으로 감지합니다.
      body: ValueListenableBuilder(
        valueListenable: starBox.listenable(),
        builder: (context, Box<Star> box, _) {
          // Hive Box에서 isStarred가 true인 Todo 목록을 가져옵니다.
          final stars = box.values.toList().cast<Star>();

          if (stars.isEmpty) {
            return const Center(
              child: Text('찜 한 투두가 없어요!'),
            );
          }

          return ListView.builder(
            itemCount: stars.length,
            itemBuilder: (context, index) {
              final star = stars[index];
              return StarListItem(
                star: star,
                onTap: () {
                  // 수정 화면으로 이동
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => TodoDetailScreen(todo: StarRepository.makeTodo(star)),
                    ),
                  );
                },
              );
            },
          );
        },
      )
    );
  }
}


