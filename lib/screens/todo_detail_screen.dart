import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo/models/todo.dart';

// cycle 열거형에 대한 표시 이름 확장
extension CycleExtension on cycle {
  String get displayName {
    switch (this) {
      case cycle.none:
        return '없음';
      case cycle.daily:
        return '매일';
      case cycle.weekly:
        return '매주';
      case cycle.monthly:
        return '매월';
    }
  }
}

class TodoDetailScreen extends StatefulWidget {
  final Todo? todo; // 수정할 Todo 항목. 새 항목 추가 시에는 null.

  const TodoDetailScreen({super.key, this.todo});

  @override
  State<TodoDetailScreen> createState() => _TodoDetailScreenState();
}

class _TodoDetailScreenState extends State<TodoDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late Importance _importance;
  late int _progress;
  late DateTime _startDate;
  late DateTime _endDate;
  late cycle _cycle;

  @override
  void initState() {
    super.initState();
    // 기존 Todo 데이터가 있으면 해당 데이터로 초기화, 없으면 기본값으로 초기화
    _title = widget.todo?.title ?? '';
    _importance = widget.todo?.importance ?? Importance.medium;
    _progress = widget.todo?.progress ?? 0;
    DateTime initDate = DateTime.now();
    initDate = DateTime(initDate.year, initDate.month, initDate.day);
    _startDate = widget.todo?.startDate ?? initDate;
    _endDate = widget.todo?.endDate ?? initDate;
    _cycle = cycle.none; // _cycle 초기화
  }

  void _saveTodo() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final todoBox = Hive.box<Todo>('todos');

      if (widget.todo == null) {
        // 새로운 Todo 추가
        if (_cycle == cycle.none) {
          final newTodo = Todo(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            title: _title,
            importance: _importance,
            progress: _progress,
            startDate: _startDate,
            endDate: _endDate,
          );
          todoBox.put(newTodo.id, newTodo);
        } else {
          // 반복 Todo 추가
          final int epoch = _cycle == cycle.daily ? 1 : _cycle == cycle.weekly ? 7 : 30;
          for(int i = 0; i < _endDate.difference(_startDate).inDays + 1; i+=epoch) {
             DateTime currentDate = _startDate.add(Duration(days: i));
             final newTodo = Todo(
              id: "${DateTime.now().millisecondsSinceEpoch}_$i", // 고유 ID 생성
              title: _title,
              importance: _importance,
              progress: 0, // 새로운 할 일은 진행률 0
              startDate: currentDate,
              endDate: currentDate, // 각 항목의 시작일과 종료일은 동일
              className: _title+_startDate.toIso8601String(), // className에 반복 그룹 식별자 저장
            );
            todoBox.put(newTodo.id, newTodo);
          }
    
        }
      } else {
        // 기존 Todo 수정 (반복 수정은 지원하지 않음)
        widget.todo!.title = _title;
        widget.todo!.importance = _importance;
        widget.todo!.progress = _progress;
        widget.todo!.startDate = _startDate;
        widget.todo!.endDate = _endDate;
        widget.todo!.save();
      }

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.todo == null ? '새 Todo 추가' : 'Todo 수정'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveTodo,
            padding: const EdgeInsets.only(right: 20.0),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(
                  labelText: '할 일',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '할 일을 입력해주세요.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
              ),
              const SizedBox(height: 16),
              // 중요도 선택
              DropdownButtonFormField<Importance>(
                //value: _importance,
                decoration: const InputDecoration(
                  labelText: '중요도',
                  border: OutlineInputBorder(),
                ),
                items: Importance.values.map((importance) {
                  return DropdownMenuItem(
                    value: importance,
                    child: Text(importance.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _importance = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              // 진행률 슬라이더
              Row(
                children: [
                  const Text('진행률'),
                  Expanded(
                    child: Slider(
                      value: _progress.toDouble(),
                      min: 0,
                      max: 100,
                      divisions: 10,
                      label: '$_progress%',
                      onChanged: (value) {
                        setState(() {
                          _progress = value.round();
                        });
                      },
                    ),
                  ),
                  Text('$_progress%'),
                ],
              ),
              const SizedBox(height: 16),
              // 반복 주기
              if (widget.todo == null) // 새 Todo 추가 시에만 반복 주기 표시
                DropdownButtonFormField<cycle>(
                  //value: _cycle,
                  decoration: const InputDecoration(
                    labelText: '반복 주기',
                    border: OutlineInputBorder(),
                  ),
                  items: cycle.values.map((cycle value) {
                    return DropdownMenuItem<cycle>(
                      value: value,
                      child: Text(value.displayName),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _cycle = value ?? cycle.none;
                    });
                  },
                ),
              if (widget.todo == null) const SizedBox(height: 16),
              // 날짜 선택 (간단한 버튼으로 구현)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.calendar_today),
                    label: Text(_cycle == cycle.none
                        ? '시작: ${_startDate.toString().substring(0, 10)}'
                        : '반복 시작: ${_startDate.toString().substring(0, 10)}'),
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _startDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (date != null) {
                        setState(() {
                          _startDate = date;
                        });
                      }
                    },
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.calendar_today),
                    label: Text(_cycle == cycle.none
                        ? '종료: ${_endDate.toString().substring(0, 10)}'
                        : '반복 종료: ${_endDate.toString().substring(0, 10)}'),
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _endDate,
                        firstDate: _startDate,
                        lastDate: DateTime(2030),
                      );
                      if (date != null) {
                        setState(() {
                          _endDate = date;
                        });
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum cycle { none, daily, weekly, monthly }
