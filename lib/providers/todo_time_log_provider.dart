import 'package:flutter/material.dart';
import 'package:todo/models/todo_time_log.dart';
import 'package:todo/repositories/todo_time_log_repository.dart';
import 'package:uuid/uuid.dart';

class TodoTimeLogProvider extends ChangeNotifier {
  static const Uuid uid = Uuid();
  final TodoTimeLogRepository _repository;
  final List<TodoTimeLog> _logs;

  TodoTimeLogProvider(this._repository) : _logs = _repository.getAllLogs();

  List<TodoTimeLog> get logs => _logs;

  List<TodoTimeLog> getLogsByDate(DateTime date) {
    return _logs.where((log) {
      return log.startTime.year == date.year &&
          log.startTime.month == date.month &&
          log.startTime.day == date.day;
    }).toList();
  }

  Future<void> addLog(
    String todoId,
    DateTime startTime,
    DateTime endTime,
  ) async {
    final log = TodoTimeLog(
      id: uid.v4(),
      todoId: todoId,
      startTime: startTime,
      endTime: endTime,
    );
    _logs.add(log);
    await _repository.create(log);
    notifyListeners();
  }
}
