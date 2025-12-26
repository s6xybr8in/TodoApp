import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:table_calendar/table_calendar.dart';
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
    final Box<Todo> todoBox = Hive.box<Todo>('todos');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Done Todos'),
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
      ),
      body: ValueListenableBuilder(
        valueListenable: todoBox.listenable(),
        builder: (context, Box<Todo> box, _) {
          final doneTodos = box.values
              .where((todo) =>
                  todo.isDone &&
                  _selectedDay != null &&
                  isSameDay(todo.doneDate, _selectedDay))
              .toList();

          List<DateTime> events = box.values
              .where((todo) => todo.isDone && todo.doneDate != null)
              .map((todo) => todo.doneDate!)
              .toList();

          return Column(
            children: [
              TableCalendar(
                eventLoader: (day) {
                  return events.where((event) => isSameDay(event, day)).toList();
                },
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
                child: doneTodos.isEmpty
                    ? const Center(
                        child: Text('선택한 날짜에 완료된 투두가 없어요!'),
                      )
                    : ListView.builder(
                        itemCount: doneTodos.length,
                        itemBuilder: (context, index) {
                          final todo = doneTodos[index];
                          return TodoListItem(
                            todo: todo,
                            onCheckboxChanged: (bool? value) {
                              todo.isDone = value ?? false;
                              if (!todo.isDone) {
                                todo.doneDate = null;
                              }
                              todo.save();
                            },
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
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
