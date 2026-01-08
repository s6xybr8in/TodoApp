import 'package:flutter/material.dart';
import 'package:todo/models/importance.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/repositories/todo_repository.dart';
import 'package:uuid/uuid.dart';

class TodoProvider extends ChangeNotifier {
  final Uuid uid = Uuid();
  final TodoRepository _todoRepository;
  final List<Todo> _todos;
  List<Todo> get todos => _todos;
  TodoProvider(this._todoRepository) : _todos = _todoRepository.getAllTodos();

  Future<Todo> addTodo(Todo todo) async {
    _todos.add(todo);
    await _todoRepository.save(todo);
    notifyListeners();
    return todo;
  }

  Future<Todo> deleteTodo(Todo todo) async {
    _todos.remove(todo);
    await _todoRepository.delete(todo);
    notifyListeners();
    return todo;
  }

  Future<void> updateTodo(Todo todo) async {
    await _todoRepository.update(todo);
    notifyListeners();
  }

  Todo makeTodo(
    String title,
    Importance importance, {
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return Todo(
      id: uid.v4(),
      title: title,
      importance: importance,
      startDate: startDate ?? DateTime.now(),
      endDate: endDate ?? DateTime.now(),
    );
  }

  String getDateKey(DateTime date) {
    return date.toIso8601String().split('T')[0];
  }

  List<Todo> get activeTodos =>
      _todos.where((todo) => !todo.isDone).toList()..sort();
  List<Todo> get staredTodos =>
      _todos.where((todo) => todo.isStared).toList()..sort();

  Map<String, List<Todo>> get doneTodosByDate {
    Map<String, List<Todo>> doneTodosByDate = {};
    for (var todo in _todos) {
      if (todo.isDone) {
        String dateKey = getDateKey(todo.doneDate!);
        if (!doneTodosByDate.containsKey(dateKey)) {
          doneTodosByDate[dateKey] = [];
        }
        doneTodosByDate[dateKey]!.add(todo);
      }
    }
    return doneTodosByDate;
  }

  Map<String, List<Todo>> get progressTodosByDate {
    Map<String, List<Todo>> progressTodosByDate = {};

    for (var todo in _todos) {
      if (!todo.isDone) {
        for (
          var date = todo.startDate;
          date.isBefore(todo.endDate.add(const Duration(days: 1)));
          date = date.add(const Duration(days: 1))
        ) {
          String dateKey = getDateKey(date);
          if (!progressTodosByDate.containsKey(dateKey)) {
            progressTodosByDate[dateKey] = [];
          }
          progressTodosByDate[dateKey]!.add(todo);
        }
      }
    }
    return progressTodosByDate;
  }

  Future<void> toggleDone(Todo todo) async {
    todo.isDone = !todo.isDone;
    todo.progress = todo.isDone ? 100 : 0;
    todo.doneDate = todo.isDone ? DateTime.now() : null;
    await _todoRepository.update(todo);
    notifyListeners();
  }

  Future<void> toggleStar(Todo todo) async {
    todo.isStared = !todo.isStared;
    await _todoRepository.update(todo);
    notifyListeners();
  }

  Todo? getTodo(String id) {
    return _todoRepository.select(id);
  }
}
