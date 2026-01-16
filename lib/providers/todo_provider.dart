import 'package:flutter/material.dart';
import 'package:todo/models/importance.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/models/todo_status.dart';
import 'package:todo/repositories/todo_repository.dart';
import 'package:uuid/uuid.dart';

class TodoProvider extends ChangeNotifier {
  static final Uuid uid = Uuid();
  final TodoRepository _todoRepository;
  final List<Todo> _todos;
  List<Todo> get todos => _todos;
  TodoProvider(this._todoRepository) : _todos = _todoRepository.getAllTodos();

  Future<Todo> addTodo(Todo todo) async {
    _todos.add(todo);
    await _todoRepository.create(todo);
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

  Todo makeTodo({
    required String title,
    Importance importance = Importance.medium,
    DateTime? startDate,
    DateTime? endDate,
    String? category,
    String? parentId,
  }) {
    return Todo(
      id: uid.v4(),
      title: title,
      importance: importance,
      startDate: startDate ?? DateTime.now(),
      endDate: endDate ?? DateTime.now(),
      category: category,
      parentId: parentId,
      status: TodoStatus.active,
    );
  }

  String getDateKey(DateTime date) {
    return date.toIso8601String().split('T')[0];
  }

  List<Todo> get activeTodos =>
      _todos.where((todo) => todo.status == TodoStatus.active).toList()..sort();

  // 부모가 없는 최상위 활성 투두만 반환 (HomeScreen용)
  List<Todo> get activeRootTodos =>
      _todos
          .where(
            (todo) => todo.status == TodoStatus.active && todo.parentId == null,
          )
          .toList()
        ..sort();

  List<Todo> get staredTodos =>
      _todos.where((todo) => todo.isStared).toList()..sort();

  Map<String, List<Todo>> get doneTodosByDate {
    Map<String, List<Todo>> doneTodosByDate = {};
    for (var todo in _todos) {
      if (todo.status != TodoStatus.active && todo.checkedDate != null) {
        String dateKey = getDateKey(todo.checkedDate!);
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
      if (todo.status == TodoStatus.active && todo.parentId == null) {
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

  Future<void> changeStatus(Todo todo, TodoStatus newStatus) async {
    todo.status = newStatus;
    todo.progress = todo.status == TodoStatus.active ? 0 : 100;
    todo.checkedDate = todo.status == TodoStatus.active ? null : DateTime.now();
    await _todoRepository.update(todo);
    notifyListeners();
  }

  Future<void> toggleDone(Todo todo) async {
    todo.status = todo.status == TodoStatus.done
        ? TodoStatus.active
        : TodoStatus.done;
    todo.progress = todo.status == TodoStatus.done ? 100 : 0;
    todo.checkedDate = todo.status == TodoStatus.done ? DateTime.now() : null;
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
