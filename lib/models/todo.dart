import 'package:hive/hive.dart';

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

  Todo({
    required this.id,
    required this.title,
    this.importance = Importance.medium,
    this.progress = 0,
    required this.startDate,
    required this.endDate,
    this.isDone = false,
    this.doneDate,
  });

  // JSON 직렬화를 위한 팩토리 생성자
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'],
      importance: Importance.values[json['importance']],
      progress: json['progress'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      isDone: json['isDone'],
      doneDate: json['doneDate'] != null ? DateTime.parse(json['doneDate']) : null,
    );
  }

  // JSON 직렬화를 위한 메서드
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'importance': importance.index,
      'progress': progress,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'isDone': isDone,
      'doneDate': doneDate?.toIso8601String(),
    };
  }
}
