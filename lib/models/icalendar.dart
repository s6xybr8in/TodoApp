
/*
"scheduleIcalString=\
BEGIN:VCALENDAR%0A\
VERSION:2.0%0A\
PRODID:Naver Calendar%0A\
CALSCALE:GREGORIAN%0A\
BEGIN:VEVENT%0A\
SEQUENCE:0%0A\
CLASS:PUBLIC%0A\
TRANSP:OPAQUE%0A\
UID:AAANhUwx08hWG3%0A\
DTSTART;TZID=Asia/Seoul:20161116T190000%0A\
DTEND;TZID=Asia/Seoul:20161116T193000%0A\
SUMMARY:%5B%EC%A0%9C%EB%AA%A9%5D+%EC%BA%98%EB%A6%B0%EB%8D%94API%EB%A1%9C+%EC%B6%94%EA%B0%80%ED%95%9C+%EC%9D%BC%EC%A0%95 %0A\
DESCRIPTION:%5B%EC%83%81%EC%84%B8%5D+%ED%9A%8C%EC%9D%98%ED%95%A9%EB%8B%88%EB%8B%A4. %0A\
LOCATION:%5B%EC%9E%A5%EC%86%8C%5D%20%EA%B7%B8%EB%A6%B0%ED%8C%A9%ED%86%A0%EB%A6%AC %0A\
CREATED:20161116T160000Z%0A\
LAST-MODIFIED:20161116T160000Z%0A\
DTSTAMP:20161116T160000Z%0A\
END:VEVENT%0A\
END:VCALENDAR"
*/
/*
BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//My Todo//KR
CALSCALE:GREGORIAN
BEGIN:VEVENT
UID:todo-20260101-001@example.com
DTSTAMP:20251230T121000Z
SUMMARY:조출하기
DTSTART;VALUE=DATE:20260101
DTEND;VALUE=DATE:20260102
DESCRIPTION:26.1.1 조출 작업
STATUS:CONFIRMED
END:VEVENT
END:VCALENDAR
*/

import 'package:hive/hive.dart';
import 'package:todo/models/daily.dart';
import 'package:todo/models/todo.dart';

String head = '''BEGIN:VCALENDAR%0A\
VERSION:2.0%0A\
PRODID:-//My Todo//KR%0A\
CALSCALE:GREGORIAN%0A\
''';
String tail = 'END:VCALENDAR';

String generateIcsTodo(String id, String title, DateTime doneDate) {
  String ics = '''BEGIN:VEVENT%0A\
    UID:$id%0A\
    DTSTAMP:${doneDate.toIso8601String().replaceAll('-', '').replaceAll(':', '').split('.').first}Z%0A\
    DTSTART:${doneDate.toIso8601String().split('T').first.replaceAll('-', '')}%0A\
    DTEND:${doneDate.add(Duration(days: 1)).toIso8601String().split('T').first.replaceAll('-', '')}%0A\
    SUMMARY:$title%0A\
    STATUS:CONFIRMED%0A\
    END:VEVENT%0A\
    ''';
    return ics; 
  }
  // %0A가 줄바꿈을 의미합니다.


Future<String> generateIcsSchedule() async{
  String content = '';
  // 모든 완료된 할 일 가져오기
  var dailyBox = Hive.box<Daily>('dailies');
  for (var daily in dailyBox.values) {
    for(var todo in daily.content!) {
      final date = daily.date;
      final utcDate = DateTime.utc(date.year, date.month, date.day);
        content += generateIcsTodo(todo.id, todo.title, utcDate);
      }
    }

  return head + content + tail;
}