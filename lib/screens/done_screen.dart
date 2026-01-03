import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo/models/daily.dart';
import 'package:todo/models/icalendar.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/widgets/done/done_calendar.dart';
import 'package:todo/widgets/done/done_todo_list.dart';
import 'package:todo/theme/app_decorations.dart';

class DoneScreen extends StatefulWidget {
  const DoneScreen({super.key});

  @override
  State<DoneScreen> createState() => _DoneScreenState();
}

class _DoneScreenState extends State<DoneScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Done Todos', style: TextStyle(fontWeight: FontWeight.bold)),
          flexibleSpace: Container(
          decoration: kAppBarDecoration,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.backup),
            onPressed: () async {
              // ICS 파일 생성
              String icsContent = await generateIcsSchedule();
              print(icsContent);
              }
      )],
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Daily>('dailies').listenable(), // 1. 'dailies' Box 감시
        builder: (context, Box<Daily> dailyBox, _) {
          return ValueListenableBuilder(
            valueListenable: Hive.box<Todo>('todos').listenable(), // 2. 'todos' Box 감시
            builder: (context, Box<Todo> todoBox, _) {
              // 이 안에서는 두 Box의 모든 변경에 반응합니다.
              Daily? dailyForSelectedDay;
              if (_selectedDay != null) {
                try {
                  final now = DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day);
                  dailyForSelectedDay = dailyBox.values.firstWhere(
                    (daily) => isSameDay(daily.date, now),
                  );
                } catch (e) {
                  // 해당 날짜에 Daily 객체가 없으면 dailyForSelectedDay는 null
                }
              }

              // dailyBox를 기준으로 캘린더 이벤트 날짜 목록 생성
              final events = <DateTime, List<dynamic>>{};
              for (final daily in dailyBox.values) {
                // table_calendar는 UTC 기준이므로 키를 UTC 날짜로 변환합니다.
                final date = DateTime.utc(daily.date.year, daily.date.month, daily.date.day);
                events[date] = daily.content?.toList() ?? [];
              }

              return Column(
                children: [
                  DoneCalendar(
                    events: events,
                    focusedDay: _focusedDay,
                    selectedDay: _selectedDay,
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    },
                  ),
                  const SizedBox(height: 8.0),
                  Expanded(
                    child: DoneTodoList(
                      dailyForSelectedDay: dailyForSelectedDay,
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}