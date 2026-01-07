import 'package:hive/hive.dart';
import 'package:todo/models/todo.dart';

class TodoRepository {
  final Box<Todo> _box;
  TodoRepository() : _box = Hive.box<Todo>('todos');
  List<Todo> getAllTodos() => _box.values.toList();

  Future<void> save(Todo todo) async {
    await _box.put(todo.id, todo);
  }

  Todo? getTodoById(String id) {
    return _box.get(id);
  }

  Future<void> delete(Todo todo) async {
    await todo.delete();
  }

  Future<void> update(Todo todo) async {
    await todo.save();
  }



}
