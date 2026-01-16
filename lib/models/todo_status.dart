import 'package:hive/hive.dart';

part 'todo_status.g.dart';

@HiveType(typeId: 2)
enum TodoStatus {
  @HiveField(0)
  active, // 진행중

  @HiveField(1)
  done,       // 완료

  @HiveField(2)
  deferred,   // 미루기

  @HiveField(3)
  failed,     // 못함

  @HiveField(4)
  insufficient // 부족함
}
