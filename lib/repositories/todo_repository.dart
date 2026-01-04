import 'package:collection/collection.dart';
import 'package:hive/hive.dart';
import 'package:todo/models/star.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/repositories/daily_repository.dart';

class TodoRepository {
  final DailyRepository _dailyRepository = DailyRepository();

  Future<void> markAsDone(Todo todo) async {
    if (todo.isDone) return; // 이미 완료된 경우 중복 실행 방지
    todo.isDone = true;
    todo.progress = 100;
    todo.doneDate = DateTime.now();
    await todo.save(); // Todo 객체의 상태를 먼저 저장

    await _dailyRepository.markTodoAsDone(todo);
  }

  Future<void> markAsUndone(Todo todo) async {
    if (!todo.isDone) return; // 이미 미완료인 경우 중복 실행 방지
    final oldDoneDate = todo.doneDate; // 날짜 정보를 지우기 전에 백업
    todo.isDone = false;
    todo.progress = 0; // 진행률 초기화
    todo.doneDate = null;
    await todo.save(); // Todo 객체의 상태를 먼저 저장

    await _dailyRepository.markTodoAsUndone(todo, oldDoneDate);
  }

  void toggleStar(Todo todo) async {
    todo.isStared = !todo.isStared;
    await todo.save();
    if (todo.isStared) {
      final starBox = Hive.box<Star>('stars');
      final newStar = Star(
        id: todo.id,
        title: todo.title,
        importance: todo.importance,
      );
      starBox.put(newStar.id, newStar);
    } else {
      final starBox = Hive.box<Star>('stars');
      final star = starBox.values.firstWhereOrNull((star) => star.id == todo.id);
      if (star != null) {
        await star.delete();
      }
    }
  }
}
