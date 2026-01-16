import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/providers/todo_time_log_provider.dart';
import 'package:todo/theme/colors.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    // Ensure we are comparing dates correctly (ignoring time for the "day")
    final logs = context.watch<TodoTimeLogProvider>().getLogsByDate(
      _selectedDate,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (picked != null && picked != _selectedDate) {
                setState(() {
                  _selectedDate = picked;
                });
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 24,
              itemBuilder: (context, hour) {
                return SizedBox(
                  height: 40,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 50,
                        child: Text(
                          '$hour',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: TColors.grey),
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: List.generate(6, (index) {
                            // 0: 00-10, 1: 10-20, ...
                            final blockStart = DateTime(
                              _selectedDate.year,
                              _selectedDate.month,
                              _selectedDate.day,
                              hour,
                              index * 10,
                            );
                            final blockEnd = blockStart.add(
                              const Duration(minutes: 10),
                            );

                            bool isOccupied = logs.any((log) {
                              // Check intersection
                              // log waits microseconds to be precise but here roughly is fine.
                              return log.startTime.isBefore(blockEnd) &&
                                  log.endTime.isAfter(blockStart);
                            });

                            return Expanded(
                              child: Container(
                                margin: const EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                  color: isOccupied
                                      ? TColors.primaryColor
                                      : TColors.grey.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
