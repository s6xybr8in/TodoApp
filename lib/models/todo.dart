import 'package:hive/hive.dart';
import 'package:todo/models/importance.dart';
import 'package:todo/models/todo_status.dart';

part 'todo.g.dart';

@HiveType(typeId: 0)
class Todo extends HiveObject implements Comparable<Todo> {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final List<String> childrenIds; // 하위 작업 ID 목록
  @HiveField(2)
  String title;
  @HiveField(3)
  int completeCount;
  @HiveField(4)
  double progress; // 0.0 ~ 1.0
  @HiveField(5)
  bool isStared; // 즐겨찾기
  @HiveField(6)
  TodoStatus status;
  @HiveField(7)
  Importance importance;
  @HiveField(8)
  DateTime startDate;
  @HiveField(9)
  DateTime endDate;
  @HiveField(10)
  DateTime? checkedDate;
  @HiveField(11)
  String? category; // 카테고리
  @HiveField(12)
  String? repetitionId;
  @HiveField(13)
  String? parentId;
  Todo({
    required this.id,
    required this.title,
    this.importance = Importance.medium,
    this.progress = 0.0,
    required this.startDate,
    required this.endDate,
    this.status = TodoStatus.active,
    List<String>? childrenIds,
    this.category,
    this.isStared = false,
    this.repetitionId,
    this.checkedDate,
    required this.parentId,
    this.completeCount = 0,
  }) : childrenIds = childrenIds ?? [];

  @override
  int compareTo(Todo other) {
    // 중요도를 기준으로 비교합니다. (high > medium > low)
    final importanceCompare = other.importance.index.compareTo(
      importance.index,
    );
    if (importanceCompare != 0) {
      return importanceCompare;
    }
    // 중요도가 같으면 제목을 기준으로 오름차순으로 비교합니다.
    return title.compareTo(other.title);
  }
}
