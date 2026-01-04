 import 'package:collection/collection.dart';
import 'package:hive/hive.dart';
import 'package:todo/models/star.dart';
import 'package:todo/models/todo.dart';

class StarRepository {
  final Box<Star> starBox = Hive.box<Star>('stars');
  
  List<Star> getAllStars() {
    final stars = starBox.values.toList();
    stars.sort();
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
    final todo = box.values.firstWhereOrNull((todo) => todo.id == star.id);
    if(todo != null){
      todo.isStared = false;
      await todo.save();
    }
  
    return star.delete();
  }

  static Todo makeTodo(Star star) {
    return Todo(
      id: star.id,
      title: star.title,
      importance: star.importance,
      startDate: DateTime.now(),
      endDate: DateTime.now(),
    );
  }
}


