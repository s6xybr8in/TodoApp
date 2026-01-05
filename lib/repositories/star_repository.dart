import 'package:collection/collection.dart';
import 'package:hive/hive.dart';
import 'package:todo/models/importance.dart';
import 'package:todo/models/star.dart';
import 'package:todo/models/todo.dart';
import 'package:uuid/uuid.dart';

class StarRepository {
  final Box<Star> starBox = Hive.box<Star>('stars');
  final Uuid uid = Uuid();
  List<Star> getAllStars() {
    final stars = starBox.values.toList();
    // stars.sort(); // Sorting is no longer needed here
    return stars;
  }

  Future<void> addStar(Star star) async {
    await starBox.put(star.id, star);
  }

  Future<void> removeStar(String id) async {
    final star = starBox.get(id);
    if (star != null) {
      await star.delete();
    }
  }

  Future<void> cascadeTodoDelete(Star star) async{
    final box = Hive.box<Todo>('todos');
    final todo = box.get(star.id); // Use get for efficient lookup
    if(todo != null){
      todo.isStared = false;
      await todo.save();
    }
  
    return star.delete();
  }

  Todo makeTodo(String title, Importance importance) {
    return Todo(
          id: uid.v4(),
          title: title,
          importance: importance,
          startDate: DateTime.now(),
          endDate: DateTime.now(),
        );
  }
}


