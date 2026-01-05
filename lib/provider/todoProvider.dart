import 'package:flutter/material.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/repositories/todo_repository.dart';

class TodoProvider extends ChangeNotifier {
  final TodoRepository _todoRepository = locatio
  List<Todo> _todos = [];

  List<Todo> get todos => _todos;

  void addTodo(Todo todo) {
    _todos.add(todo);
    notifyListeners();
  }

  void removeTodoAt(int index) {
    if (index >= 0 && index < _todos.length) {
      _todos.removeAt(index);
      notifyListeners();
    }
  }

}