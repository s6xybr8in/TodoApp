import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo/models/daily.dart';
import 'package:todo/models/icalendar.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/screens/todo_detail_screen.dart';
import 'package:todo/widgets/todo_list_item.dart';

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
    // 데이터 소스를 dailyBox로 변경
    final Box<Daily> dailyBox = Hive.box<Daily>('dailies');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Done Todos', style: TextStyle(fontWeight: FontWeight.bold)),
          flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF4F46E5), // indigo
                Color(0xFF7C3AED), // violet
                Color(0xFF2563EB), // blue
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
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
        // 감시 대상을 dailyBox로 변경
        valueListenable: dailyBox.listenable(),
        builder: (context, Box<Daily> box, _) {
          // dailyBox에서 완료된 Todo 목록을 계산
          List<Todo> doneTodos = [];
          Daily? dailyForSelectedDay; // Declare dailyForSelectedDay outside try-catch
          if (_selectedDay != null) {
            try {
              final now = DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day);
              dailyForSelectedDay = box.values.firstWhere(
                (daily) => isSameDay(daily.date, now),
              );
            } catch (e) {
              // 해당 날짜에 Daily 객체가 없으면 dailyForSelectedDay는 null
            }
          }

          // dailyBox를 기준으로 캘린더 이벤트 날짜 목록 생성
          final events = <DateTime, List<dynamic>>{};
          for (final daily in box.values) {
            // table_calendar는 UTC 기준이므로 키를 UTC 날짜로 변환합니다.
            final date = DateTime.utc(daily.date.year, daily.date.month, daily.date.day);
            events[date] = daily.content?.toList() ?? [];
          }

          return Column(
            children: [
              TableCalendar(
                eventLoader: (day) {
                  return events[day] ?? [];
                },
               calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {
                if (events.isNotEmpty) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: events.map((event) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 1.5),
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color.fromARGB(255, 30, 0, 68), // 이벤트 종류에 따라 색상 분기 가능
                        ),
                      );
                    }).toList(),
                  );
                }
                return null;
                },
                ),


                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                calendarStyle: const CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Color(0xFF7C3AED),
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Color(0xFF4F46E5),
                    shape: BoxShape.circle,
                  ),
                ),
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
              ),
              const SizedBox(height: 8.0),
              Expanded(
                child: () {
                  if (dailyForSelectedDay == null || !dailyForSelectedDay.isInBox || dailyForSelectedDay.content == null) {
                    return const Center(
                      child: Text('선택한 날짜에 완료된 투두가 없어요!'),
                    );
                  }

                  final doneTodos = dailyForSelectedDay.content!
                      .where((todo) => todo.isDone)
                      .toList();

                  if (doneTodos.isEmpty) {
                    return const Center(
                      child: Text('선택한 날짜에 완료된 투두가 없어요!'),
                    );
                  }

                  return ListView.builder(
                    itemCount: doneTodos.length,
                    itemBuilder: (context, index) {
                      final todo = doneTodos[index];
                      return TodoListItem(
                        todo: todo,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  TodoDetailScreen(todo: todo),
                            ),
                          );
                        },
                      );
                    },
                  );
                }(),
              ),
            ],
          );
        },
      ),
    );
  }
}