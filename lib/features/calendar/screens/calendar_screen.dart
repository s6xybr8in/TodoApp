import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/features/calendar/widgets/base_calendar.dart';
import 'package:todo/features/calendar/widgets/calendar_todo_list.dart';
import 'package:todo/providers/todo_provider.dart';
import 'package:todo/theme/colors.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool _showProgress = true; // true: progress, false: done

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    // Optimization notes:
    // 1. We access the string-keyed maps directly to avoid costly date parsing loop.
    // 2. BaseCalendar now accepts Map<String, List> directly.
    final TodoProvider todoProvider = context.watch<TodoProvider>();
    final doneMapList = todoProvider.doneTodosByDate;
    final progressMapList = todoProvider.progressTodosByDate;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                child: SegmentedButton<bool>(
                  showSelectedIcon: false,
                  segments: const <ButtonSegment<bool>>[
                    ButtonSegment<bool>(
                      value: true,
                      icon: Icon(Icons.schedule),
                      // label: Text("진행중"),
                    ),
                    ButtonSegment<bool>(
                      value: false,
                      icon: Icon(Icons.done),
                      // label: Text("완료"),
                    ),
                  ],
                  selected: <bool>{_showProgress},
                  onSelectionChanged: (Set<bool> newSelection) {
                    setState(() {
                      _showProgress = newSelection.first;
                    });
                  },
                ),
              ),
            ),
            const Text('달력'),
          ],
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
            },
          ),
        ],
      ),
      body: Column(
        children: [
          BaseCalendar(
            events: _showProgress ? progressMapList : doneMapList,
            focusedDay: _focusedDay,
            selectedDay: _selectedDay,
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            markerColor: _showProgress
                ? TColors.mediumImportanceColor
                : TColors.calendarMarkerColor,
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: CalendarTodoList(
              todoMapList: _showProgress ? progressMapList : doneMapList,
              selectedDay: _selectedDay,
              emptyMessage: _showProgress
                  ? '선택한 날짜에 진행 중인 투두가 없어요!'
                  : '선택한 날짜에 완료된 투두가 없어요!',
            ),
          ),
        ],
      ),
    );
  }
}
