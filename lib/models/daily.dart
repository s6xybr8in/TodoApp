import 'package:hive/hive.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo/debug/debug.dart';
import 'package:todo/models/todo.dart';

part 'daily.g.dart';

@HiveType(typeId: 2)
class Daily extends HiveObject {
  @HiveField(0)
  DateTime date;

  @HiveField(1)
  HiveList<Todo>? content;

  int get count => content?.length ?? 0;

  Daily({required this.date});

  /// Todo를 완료 상태로 표시하고 오늘 날짜의 Daily에 추가합니다.
  /// Daily가 없으면 새로 생성합니다.
  static Future<void> markTodoAsDone(Todo todo) async {
    final dailyBox = Hive.box<Daily>('dailies');
    Daily? dailyForDate;

    try {
      // 날짜에 해당하는 Daily 객체를 찾음
      dailyForDate =
          dailyBox.values.firstWhere((d) => isSameDay(d.date, todo.doneDate!));
    } catch (e) {
      dailyForDate = null; // 없음
    }

    // Daily 객체가 없으면 새로 생성하여 Box에 추가
    if (dailyForDate == null) {
      dailyForDate = Daily(date: todo.doneDate!);
      await dailyBox.add(dailyForDate);
    }

    // Daily 객체의 content 리스트에 현재 Todo를 추가 (중복 방지)
    dailyForDate.content ??= HiveList(Hive.box<Todo>('todos'));

    if (!dailyForDate.content!.contains(todo)) {
      dailyForDate.content!.add(todo);
      await dailyForDate.save(); // HiveList 변경사항을 저장
    }
    kPrint('dailyBox length: ${dailyBox.length}');
  }

  /// Todo를 미완료 상태로 되돌리고 Daily에서 제거합니다.
  /// Daily에 다른 Todo가 없으면 Daily 객체 자체를 삭제합니다.
  static Future<void> markTodoAsUndone(Todo todo, DateTime? oldDoneDate) async {

    // 기존 doneDate에 해당하는 Daily 객체에서 현재 Todo를 제거
    if (oldDoneDate != null) {
      final dailyBox = Hive.box<Daily>('dailies');
      try {
        final dailyForDate =
            dailyBox.values.firstWhere((d) => isSameDay(d.date, oldDoneDate));
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
      } catch (e) {
        // Daily 객체가 없거나, Todo가 content에 없었으면 아무것도 하지 않음
      }
    }
    //print('dailyBox length: ${dailyBox.length}');
  }
}