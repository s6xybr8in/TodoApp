import 'package:hive/hive.dart';
import 'package:todo/models/importance.dart';
part 'todo.g.dart';



@HiveType(typeId: 0)
class Todo extends HiveObject implements Comparable<Todo> {
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
  String repetitionId;

  @HiveField(9)
  bool isStared;


  Todo({
    required this.id,
    required this.title,
    this.importance = Importance.medium,
    this.progress = 0,
    required this.startDate,
    required this.endDate,
    this.isDone = false,
    this.doneDate,
    this.repetitionId = '',
    this.isStared = false,
  });

  


  @override
  int compareTo(Todo other) {
    // 중요도를 기준으로 비교합니다. (high > medium > low)
    final importanceCompare = other.importance.index.compareTo(importance.index);
    if (importanceCompare != 0) {
      return importanceCompare;
    }
    // 중요도가 같으면 제목을 기준으로 오름차순으로 비교합니다.
    return title.compareTo(other.title);
  }
}
