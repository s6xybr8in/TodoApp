import 'package:hive/hive.dart';

part 'importance.g.dart';
@HiveType(typeId: 1)
enum Importance {
  @HiveField(0)
  low,
  @HiveField(1)
  medium,
  @HiveField(2)
  high,
}

