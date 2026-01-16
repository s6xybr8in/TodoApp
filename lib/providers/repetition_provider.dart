import 'package:flutter/material.dart';
import 'package:todo/models/repetition.dart';
import 'package:todo/repositories/repetition_repository.dart';

class RepetitionProvider extends ChangeNotifier {
  final RepetitionRepository _repository;

  RepetitionProvider(this._repository);

  Future<void> addRepetition(Repetition repetition) async {
    await _repository.create(repetition);
    notifyListeners();
  }

  Repetition? getRepetition(String id) {
    return _repository.select(id);
  }

  Future<void> updateRepetition(Repetition repetition) async {
    await _repository.update(repetition);
    notifyListeners();
  }

  Future<void> deleteRepetition(Repetition repetition) async {
    await _repository.delete(repetition);
    notifyListeners();
  }
}
