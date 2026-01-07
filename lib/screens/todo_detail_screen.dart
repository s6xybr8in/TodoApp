import 'package:flutter/material.dart';
import 'package:todo/models/importance.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/providers/todo_provider.dart';


class TodoDetailScreen extends StatefulWidget {
  final Todo? todo; // 수정할 Todo 항목. 새 항목 추가 시에는 null.
  final TodoProvider todoProvider;  
  final String? title;
  final Importance? importance;
  const TodoDetailScreen({super.key, this.todo, required this.todoProvider, this.title, this.importance});

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
  late int _repetitionDays;
  late bool _isRepetitive;

  @override
  void initState() {
    super.initState();
    // 기존 Todo 데이터가 있으면 해당 데이터로 초기화, 없으면 기본값으로 초기화
    _title = widget.title ?? widget.todo?.title ?? ''; 
    _importance = widget.importance ?? widget.todo?.importance ?? Importance.medium;
    _progress = widget.todo?.progress ?? 0;
    DateTime initDate = DateTime.now();
    initDate = DateTime(initDate.year, initDate.month, initDate.day);
    _startDate = widget.todo?.startDate ?? initDate;
    _endDate = widget.todo?.endDate ?? initDate;
    _repetitionDays = 0;
    _isRepetitive = false;
  }

  void _saveTodo() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final newTodo = widget.todoProvider.makeTodo(_title, _importance);
      await widget.todoProvider.addTodo(newTodo);

      if (mounted) {
        Navigator.of(context).pop();
      }
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
                initialValue: _importance,
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
                Column(
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: _isRepetitive,
                          onChanged: (value) {
                            setState(() {
                              _isRepetitive = value!;
                              if (_isRepetitive && _repetitionDays == 0) {
                                _repetitionDays = 1; // Default to 1 day if repetition is enabled
                              } else if (!_isRepetitive) {
                                _repetitionDays = 0; // Reset if repetition is disabled
                              }
                            });
                          },
                        ),
                        const Text('반복 설정'),
                      ],
                    ),
                    if (_isRepetitive)
                      TextFormField(
                        initialValue: _repetitionDays.toString(),
                        decoration: const InputDecoration(
                          labelText: '반복 간격 (일)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (_isRepetitive && (value == null || value.isEmpty || int.tryParse(value) == null || int.parse(value) <= 0)) {
                            return '유효한 반복 간격(일)을 입력해주세요.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _repetitionDays = int.tryParse(value!) ?? 0;
                        },
                        onChanged: (value) {
                          setState(() {
                            _repetitionDays = int.tryParse(value) ?? 0;
                          });
                        },
                      ),
                  ],
                ),
              if (widget.todo != null) const SizedBox(height: 16),
              // 날짜 선택 (간단한 버튼으로 구현)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.calendar_today),
                    label: Text(
                        '시작: ${_startDate.toString().substring(5, 10)}'),
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
                    label: Text(
                        '종료: ${_endDate.toString().substring(5, 10)}'),
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


