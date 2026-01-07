import 'package:hive/hive.dart';
import 'package:todo/models/star.dart';

class StarRepository {
  // 1. Box 이름을 상수로 관리하여 오타 방지
  static const String boxName = 'stars';
  final Box<Star> _box = Hive.box<Star>(boxName);

  // 2. 외부에서 Box에 직접 접근하는 것은 캡슐화 위반일 수 있음
  // 필요한 데이터만 메서드를 통해 제공하는 것이 좋습니다.
  List<Star> getAllStars() {
    return _box.values.toList();
  }

  // 3. 특정 ID로 Star를 찾는 기능 추가 (조회 전용)
  Star? getStarById(String id) {
    return _box.get(id);
  }

  // 4. Star 생성 로직 개선
  // 'makeStar'는 객체만 만들고, 'addStar'는 저장만 하도록 분리하거나
  // 아래처럼 저장까지 완료된 객체를 반환하는 것이 편리합니다.
  Future<Star> createAndAddStar(String id) async {
    final newStar = Star(id: id);
    await _box.put(id, newStar);
    return newStar;
  }

  // 5. 업데이트 및 추가 통합
  Future<void> saveStar(Star star) async {
    await _box.put(star.id, star);
  }

  // 6. 삭제 로직 안정화
  Future<void> deleteStar(String id) async {
    if (_box.containsKey(id)) {
      await _box.delete(id);
    }
  }
}