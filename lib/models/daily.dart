import 'package:hive/hive.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo/models/todo.dart';

part 'daily.g.dart';

@HiveType(typeId: 2)
class Daily extends HiveObject {
  @HiveField(0)
  final String id; // YYYY-MM-DD 형식

  @HiveField(1)
  HiveList<Todo>? content;

  // 기존 코드 호환성을 위해 id를 DateTime으로 변환하는 getter
  DateTime get date => DateTime.parse(id);

  int get count => content?.length ?? 0;

  Daily({required this.id});

  bool isSameDayAs(DateTime other) {
    return isSameDay(date, other);
  }
}