
import 'package:flutter/material.dart';
import 'package:todo/models/star.dart';
import 'package:todo/repositories/star_repository.dart';

class StarProvider extends ChangeNotifier {
  final StarRepository _starRepository;
  final List<Star> _stars;
  StarProvider(this._starRepository) : _stars = _starRepository.getAllStars();
  List<Star> get stars => _stars;

  Future<void> deletebyStar(Star? star) async {
    await _starRepository.deleteStar(star?.id ?? '');
    if(star != null) _stars.remove(star);
    notifyListeners();
  }

  Future<void> deletebyID(String id) async {
    final star = _starRepository.getStarById(id);
    if(star != null) stars.remove(star);
    notifyListeners();
  }

  Future<void> addStar(String id) async {
    final newStar = await _starRepository.createAndAddStar(id);
    _stars.add(newStar);
    notifyListeners();
  }

  
}