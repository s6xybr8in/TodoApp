import 'package:hive/hive.dart';
import 'package:todo/models/importance.dart';
import 'package:todo/models/star.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/repositories/daily_repository.dart';
import 'package:uuid/uuid.dart';

class TodoRepository {
  final DailyRepository _dailyRepository;
  final Box<Todo> _todoBox = Hive.box<Todo>('todos');
  final Uuid uid = Uuid();
  // 생성자를 통해 DailyRepository를 주입받습니다.
  TodoRepository(this._dailyRepository);

  Todo makeTodo(String title, Importance importance, {DateTime? startDate, DateTime? endDate}) {
    return Todo(
          id: uid.v4(),
          title: title,
          importance: importance,
          startDate: startDate ?? DateTime.now(),
          endDate: endDate ?? DateTime.now(),
        );
  }
  Future<void> saveOrUpdateTodo({
    required String title,
    required Importance importance,
    required int progress,
    required DateTime startDate,
    required DateTime endDate,
    required bool isRepetitive,
    required int repetitionDays,
    Todo? existingTodo,
  }) async {
    if (existingTodo == null) {
      // 새로운 Todo 추가
      if (!isRepetitive || repetitionDays <= 0) {
        // 단일 Todo
        final newTodo = Todo(
          id: uid.v4(),
          title: title,
          importance: importance,
          progress: progress,
          startDate: startDate,
          endDate: endDate,
        );
        await _todoBox.put(newTodo.id, newTodo);
      } else {
        // 반복 Todo
        for (int i = 0; i <= endDate.difference(startDate).inDays; i += repetitionDays) {
          DateTime currentDate = startDate.add(Duration(days: i));
          String repetitionId = uid.v4(); // 반복 그룹 ID 생성
          final newTodo = Todo(
            id: uid.v4(),
            title: title,
            importance: importance,
            progress: 0,
            startDate: currentDate,
            endDate: currentDate,
            repetitionId: repetitionId, // 반복 그룹 ID
          );
          await _todoBox.put(newTodo.id, newTodo);
        }
      }
    } else {
      // 기존 Todo 수정 (반복 수정은 지원하지 않음)
      existingTodo.title = title;
      existingTodo.importance = importance;
      existingTodo.progress = progress;
      existingTodo.startDate = startDate;
      existingTodo.endDate = endDate;
      await existingTodo.save();
    }
  }

  Future<void> deleteTodo(Todo todo) async {
    await todo.delete();
  }

  Future<void> markAsDone(Todo todo) async {
    if (todo.isDone) return; // 이미 완료된 경우 중복 실행 방지
    todo.isDone = true;
    todo.progress = 100;
    todo.doneDate = DateTime.now();
    await todo.save(); // Todo 객체의 상태를 먼저 저장

    await _dailyRepository.markTodoAsDone(todo);
  }

  Future<void> markAsUndone(Todo todo) async {
    if (!todo.isDone) return; // 이미 미완료인 경우 중복 실행 방지
    final oldDoneDate = todo.doneDate; // 날짜 정보를 지우기 전에 백업
    todo.isDone = false;
    todo.progress = 0; // 진행률 초기화
    todo.doneDate = null;
    await todo.save(); // Todo 객체의 상태를 먼저 저장

    await _dailyRepository.markTodoAsUndone(todo, oldDoneDate);
  }

  void toggleStar(Todo todo) async {
    todo.isStared = !todo.isStared;
    await todo.save();

    final starBox = Hive.box<Star>('stars');
    if (todo.isStared) {
      final newStar = Star(id: todo.id);
      starBox.put(newStar.id, newStar);
    } else {
      final star = starBox.get(todo.id);
      if (star != null) {
        await star.delete();
      }
    }
  }
}
