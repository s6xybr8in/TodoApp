import 'package:hive/hive.dart';
import 'package:todo/models/repetition.dart';

class RepetitionRepository {
  final Box<Repetition> _box;
  RepetitionRepository() : _box = Hive.box<Repetition>('repetitions');
  List<Repetition> getAllRepetitions() => _box.values.toList();
  // curd operations
  Future<void> create(Repetition repetition) async {
    await _box.put(repetition.id, repetition);
  }

  Repetition? select(String id) {
    return _box.get(id);
  }

  Future<void> delete(Repetition repetition) async {
    await repetition.delete();
  }

  Future<void> update(Repetition repetition) async {
    await repetition.save();
  }

}
