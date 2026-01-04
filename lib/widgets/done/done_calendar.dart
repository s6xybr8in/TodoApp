import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo/theme/colors.dart';

class DoneCalendar extends StatelessWidget {
  final Map<DateTime, List<dynamic>> events;
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final Function(DateTime, DateTime) onDaySelected;

  const DoneCalendar({
    super.key,
    required this.events,
    required this.focusedDay,
    required this.selectedDay,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      eventLoader: (day) {
        return events[day] ?? [];
      },
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, date, events) {
          if (events.isNotEmpty) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: events.take(3).map((event) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 1.5),
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: TColors.calendarMarkerColor,
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
      focusedDay: focusedDay,
      selectedDayPredicate: (day) {
        return isSameDay(selectedDay, day);
      },
      onDaySelected: onDaySelected,
      calendarStyle: const CalendarStyle(
        todayDecoration: BoxDecoration(
          color: TColors.calendarTodayDecoration,
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: TColors.calendarSelectedDecoration,
          shape: BoxShape.circle,
        ),
      ),
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
    );
  }
}
