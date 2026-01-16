import 'package:hive/hive.dart';

part 'todo_time_log.g.dart';

@HiveType(typeId: 5)
class TodoTimeLog extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String todoId;

  @HiveField(2)
  final DateTime startTime;

  @HiveField(3)
  final DateTime endTime;

  TodoTimeLog({
    required this.id,
    required this.todoId,
    required this.startTime,
    required this.endTime,
  });

  Duration get duration => endTime.difference(startTime);
}
