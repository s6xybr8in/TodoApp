import 'package:hive/hive.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo/models/daily.dart';

part 'todo.g.dart';

// 중요도를 나타내는 열거형
@HiveType(typeId: 1)
enum Importance {
  @HiveField(0)
  low,
  @HiveField(1)
  medium,
  @HiveField(2)
  high,
}

@HiveType(typeId: 0)
class Todo extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  Importance importance;

  @HiveField(3)
  int progress; // 진행률 (0-100)

  @HiveField(4)
  DateTime startDate;

  @HiveField(5)
  DateTime endDate;

  @HiveField(6)
  bool isDone;

  @HiveField(7)
  DateTime? doneDate;

  @HiveField(8)
  String className;

  Todo({
    required this.id,
    required this.title,
    this.importance = Importance.medium,
    this.progress = 0,
    required this.startDate,
    required this.endDate,
    this.isDone = false,
    this.doneDate,
    this.className = '',
  });
  Future<void> markAsDone() async {
    if (isDone) return; // 이미 완료된 경우 중복 실행 방지
    isDone = true;
    progress = 100;
    doneDate = DateTime.now();
    await save(); // Todo 객체의 상태를 먼저 저장

    await Daily.markTodoAsDone(this);
  }

  Future<void> markAsUndone() async {
    if (!isDone) return; // 이미 미완료인 경우 중복 실행 방지
    final oldDoneDate = doneDate; // 날짜 정보를 지우기 전에 백업
    isDone = false;
    progress = 0; // 진행률 초기화
    doneDate = null;
    await save(); // Todo 객체의 상태를 먼저 저장
    
    await Daily.markTodoAsUndone(this,oldDoneDate);
  }
}
