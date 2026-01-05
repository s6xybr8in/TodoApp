
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo/models/daily.dart';
import 'package:todo/repositories/daily_repository.dart';

class Dailyprovider extends ChangeNotifier{
  final DailyRepository _dailyRepository = DailyRepository();
  List<Daily> getAllDailies() {
    final dailies = _dailyRepository.getBox().values.toList();
    dailies.sort((a, b) => b.id.compareTo(a.id)); // 최신 날짜가 위로 오도록 정렬
    return dailies;
  }

  Future<void> save(Daily daily) async{
    await _dailyRepository.save(daily);
    notifyListeners();
  }

  Future<void> markTodoAsDone(Todo todo) async {
      final dailyBox = Hive.box<Daily>('dailies');
      final dateKey = formatDateKey(todo.doneDate!);
      Daily? dailyForDate = dailyBox.get(dateKey);

      // Daily 객체가 없으면 새로 생성하여 Box에 추가
      if (dailyForDate == null) {
        dailyForDate = Daily(id: dateKey);
        await dailyBox.put(dateKey, dailyForDate);
      }

      // Daily 객체의 content 리스트에 현재 Todo를 추가 (중복 방지)
      dailyForDate.content ??= HiveList(Hive.box<Todo>('todos'));

      if (!dailyForDate.content!.contains(todo)) {
        dailyForDate.content!.add(todo);
        await dailyForDate.save(); // HiveList 변경사항을 저장
      }
    }

    /// Todo를 미완료 상태로 되돌리고 Daily에서 제거합니다.
    /// Daily에 다른 Todo가 없으면 Daily 객체 자체를 삭제합니다.
    Future<void> markTodoAsUndone(Todo todo, DateTime? oldDoneDate) async {
      // 기존 doneDate에 해당하는 Daily 객체에서 현재 Todo를 제거
      if (oldDoneDate != null) {
        final dailyBox = Hive.box<Daily>('dailies');
        final dateKey = formatDateKey(oldDoneDate);
        final dailyForDate = dailyBox.get(dateKey);

        if (dailyForDate != null) {
          final removed = dailyForDate.content?.remove(todo) ?? false;
          if (removed) {
            // content 리스트가 비어 있으면 Daily 객체 자체를 삭제
            if (dailyForDate.content?.isEmpty ?? true) {
              await dailyForDate.delete();
            } else {
              // 그렇지 않으면 변경사항만 저장
              await dailyForDate.save();
            }
          }
        }
      }
    }
}