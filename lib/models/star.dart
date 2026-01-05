import 'package:hive/hive.dart';

part 'star.g.dart';

@HiveType(typeId: 3)
class Star extends HiveObject {

  @HiveField(0)
  final String id;

  Star({
    required this.id,
  });

}
