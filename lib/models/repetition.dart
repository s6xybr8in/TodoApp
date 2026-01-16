import 'package:hive/hive.dart';

part 'repetition.g.dart';

@HiveType(typeId: 3)
enum RepeatType {
  @HiveField(0)
  daily,
  @HiveField(1)
  weekly,
  @HiveField(2)
  monthly,
  @HiveField(3)
  yearly,
}

@HiveType(typeId: 4)
class Repetition extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  RepeatType type; // 반복 주기 (일/주/월/년)

  @HiveField(2)
  int interval; // 반복 간격 (예: 2주마다 -> type: weekly, interval: 2)

  @HiveField(3)
  List<int>? daysOfWeek; // 요일별 반복 (1: 월요일 ~ 7: 일요일), 주간 반복일 때 사용

  @HiveField(4)
  DateTime? endDate; // 반복 종료일 (없으면 계속 반복)

  Repetition({
    required this.id,
    this.type = RepeatType.daily,
    this.interval = 1,
    this.daysOfWeek,
    this.endDate,
  });

  // 다음 일정 날짜 계산
  DateTime? getNextDate(DateTime currentDate) {
    // 1. 종료일 체크
    if (endDate != null && currentDate.isAfter(endDate!)) return null;

    DateTime nextDate;

    switch (type) {
      case RepeatType.daily:
        nextDate = currentDate.add(Duration(days: interval));
        break;
      case RepeatType.weekly:
        nextDate = currentDate.add(Duration(days: 7 * interval));
        break;
      case RepeatType.monthly:
        // 월 단위 계산 (단순화된 버전)
        // 31일 등 말일 처리는 DateTime 생성자가 자동으로 넘어가는 것을 허용하거나
        // 비즈니스 로직에 따라 말일 보정(last day of month)이 필요할 수 있습니다.
        int nextYear = currentDate.year;
        int nextMonth = currentDate.month + interval;
        while (nextMonth > 12) {
          nextYear++;
          nextMonth -= 12;
        }
        nextDate = DateTime(
          nextYear,
          nextMonth,
          currentDate.day,
          currentDate.hour,
          currentDate.minute,
        );
        break;
      case RepeatType.yearly:
        nextDate = DateTime(
          currentDate.year + interval,
          currentDate.month,
          currentDate.day,
          currentDate.hour,
          currentDate.minute,
        );
        break;
    }

    // 계산된 다음 날짜가 종료일을 넘기면 null 반환
    if (endDate != null && nextDate.isAfter(endDate!)) {
      return null;
    }

    return nextDate;
  }
}
