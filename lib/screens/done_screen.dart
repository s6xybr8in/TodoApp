import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/providers/todo_provider.dart';
import 'package:todo/utils/icalendar.dart';
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
    final TodoProvider todoProvider = context.watch<TodoProvider>();
    final doneMapList = todoProvider.getDoneTodosByDate();

      // dailyBox를 기준으로 캘린더 이벤트 날짜 목록 생성
      final events = <DateTime, List<Todo>>{};
      for (final daily in doneMapList.keys) {
        DateTime eventKey = DateTime.parse("${daily}T00:00:00Z");
        events[eventKey] = doneMapList[daily] ?? [];
      }
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
              /*
              String icsContent = await generateIcsSchedule();
              kPrint(icsContent);
              */
              }
      )],
      ),
      body:  Column(
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
                     doneMapList: doneMapList, selectedDay: _selectedDay,
                    ),
                  ),
                ],
              )
              );
            }
}