import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/models/todo_status.dart';
import 'package:todo/providers/todo_provider.dart';
import 'package:todo/providers/todo_time_log_provider.dart';
import 'package:todo/theme/colors.dart';

class StopWatchScreen extends StatefulWidget {
  const StopWatchScreen({super.key});

  @override
  State<StopWatchScreen> createState() => _StopWatchScreenState();
}

class _StopWatchScreenState extends State<StopWatchScreen> {
  Todo? _selectedTodo;
  Timer? _timer;
  int _elapsedSeconds = 0;
  DateTime? _startTime;
  bool _isRunning = false;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    if (_selectedTodo == null) return;

    setState(() {
      _isRunning = true;
      _startTime = DateTime.now();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _elapsedSeconds++;
        });
      });
    });
  }

  void _stopTimer() {
    if (!_isRunning) return;

    _timer?.cancel();
    final endTime = DateTime.now();

    if (_startTime != null && _selectedTodo != null) {
      context.read<TodoTimeLogProvider>().addLog(
        _selectedTodo!.id,
        _startTime!,
        endTime,
      );
    }

    setState(() {
      _isRunning = false;
      _startTime = null;
      _elapsedSeconds = 0;
    });
  }

  String _formatTime(int seconds) {
    final int h = seconds ~/ 3600;
    final int m = (seconds % 3600) ~/ 60;
    final int s = seconds % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final todos = context.watch<TodoProvider>().todos;
    final activeRootedTodos = todos
        .where((t) => t.status == TodoStatus.active && t.parentId == null)
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Stopwatch')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<Todo>(
              isExpanded: true,
              value: _selectedTodo,
              hint: const Text('Select a Todo'),
              items: activeRootedTodos.map((todo) {
                return DropdownMenuItem(value: todo, child: Text(todo.title));
              }).toList(),
              onChanged: _isRunning
                  ? null
                  : (Todo? value) {
                      setState(() {
                        _selectedTodo = value;
                      });
                    },
            ),
            const Spacer(),
            Text(
              _formatTime(_elapsedSeconds),
              style: const TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.bold,
                color: TColors.primaryColor,
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!_isRunning)
                  ElevatedButton.icon(
                    onPressed: _selectedTodo == null ? null : _startTimer,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Start'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                  )
                else
                  ElevatedButton.icon(
                    onPressed: _stopTimer,
                    icon: const Icon(Icons.stop),
                    label: const Text('Stop'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TColors.error,
                      foregroundColor: TColors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                  ),
              ],
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
