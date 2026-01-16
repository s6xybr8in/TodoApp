import 'package:hive/hive.dart';
import 'package:todo/models/todo_time_log.dart';

class TodoTimeLogRepository {
  final Box<TodoTimeLog> _box;

  TodoTimeLogRepository() : _box = Hive.box<TodoTimeLog>('todo_time_logs');

  List<TodoTimeLog> getAllLogs() => _box.values.toList();

  Future<void> create(TodoTimeLog log) async {
    await _box.put(log.id, log);
  }

  Future<void> delete(TodoTimeLog log) async {
    await log.delete();
  }
}
