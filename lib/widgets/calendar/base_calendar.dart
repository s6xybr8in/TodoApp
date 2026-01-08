import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo/theme/colors.dart';

class BaseCalendar extends StatelessWidget {
  /// Map with keys as "YYYY-MM-DD" string
  final Map<String, List<dynamic>> events;
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final Function(DateTime, DateTime) onDaySelected;
  final Color markerColor;

  const BaseCalendar({
    super.key,
    required this.events,
    required this.focusedDay,
    required this.selectedDay,
    required this.onDaySelected,
    this.markerColor = const Color(0xFF6D28D9), // Default: Deep Purple
  });

  String _getDateKey(DateTime date) {
    return date.toIso8601String().split('T')[0];
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      eventLoader: (day) {
        // Optimized: O(1) lookup instead of iterating through keys
        final key = _getDateKey(day);
        return events[key] ?? [];
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
                    color: markerColor,
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
      // Optimization: Improve scrolling performance
      pageAnimationEnabled: true,
      shouldFillViewport: false,
    );
  }
}
