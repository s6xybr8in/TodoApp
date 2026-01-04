import 'package:hive/hive.dart';
import 'package:todo/models/importance.dart';

part 'star.g.dart';

@HiveType(typeId: 3)
class Star extends HiveObject implements Comparable<Star> {

  @HiveField(0)
  final String id;
  @HiveField(1)
  String title;
  @HiveField(2)
  Importance importance;

  Star({
    required this.id,
    required this.title,
    required this.importance,
  });

  @override
  int compareTo(Star other) {
    // 중요도를 기준으로 비교합니다. (high > medium > low)
    final importanceCompare = other.importance.index.compareTo(importance.index);
    if (importanceCompare != 0) {
      return importanceCompare;
    }
    // 중요도가 같으면 제목을 기준으로 오름차순으로 비교합니다.
    return title.compareTo(other.title);
  }

}
