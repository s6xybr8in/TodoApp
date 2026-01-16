import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/models/importance.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/providers/todo_provider.dart';

class TodoDetailScreen extends StatefulWidget {
  final Todo? todo; // 수정할 Todo 항목. 새 항목 추가 시에는 null.
  final String? title;
  final Importance? importance;
  const TodoDetailScreen({super.key, this.todo, this.title, this.importance});

  @override
  State<TodoDetailScreen> createState() => _TodoDetailScreenState();
}

class _TodoDetailScreenState extends State<TodoDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late Importance _importance;
  late double _progress;
  late DateTime _startDate;
  late DateTime _endDate;
  String? _category;
  late int _repetitionDays;
  late bool _isRepetitive;

  @override
  void initState() {
    super.initState();
    // 기존 Todo 데이터가 있으면 해당 데이터로 초기화, 없으면 기본값으로 초기화
    _title = widget.title ?? widget.todo?.title ?? '';
    _importance =
        widget.importance ?? widget.todo?.importance ?? Importance.medium;
    _progress = widget.todo?.progress ?? 0.0;
    _category = widget.todo?.category;

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
      final todoProvider = context.read<TodoProvider>();
      if (widget.todo == null) {
        final newTodo = todoProvider.makeTodo(
          title: _title,
          importance: _importance,
          startDate: _startDate,
          endDate: _endDate,
        );
        newTodo.progress = _progress;
        newTodo.category = _category;

        await todoProvider.addTodo(newTodo);
      } else {
        final editing = widget.todo!;
        editing.title = _title;
        editing.importance = _importance;
        editing.progress = _progress;
        editing.startDate = _startDate;
        editing.endDate = _endDate;
        editing.category = _category;
        await todoProvider.updateTodo(editing);
      }

      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  String _formatDate(DateTime d) {
    final mm = d.month.toString().padLeft(2, '0');
    final dd = d.day.toString().padLeft(2, '0');
    return '${d.year}.$mm.$dd';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isEditing = widget.todo != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? '할 일 수정' : '새로운 할 일')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Title
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextFormField(
                  initialValue: _title,
                  decoration: const InputDecoration(
                    labelText: '할 일',
                    hintText: '무엇을 할까요?',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return '할 일을 입력해주세요.';
                    }
                    return null;
                  },
                  onSaved: (value) => _title = value!.trim(),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Category
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextFormField(
                  initialValue: _category,
                  decoration: const InputDecoration(
                    labelText: '카테고리',
                    hintText: '예: 업무, 공부, 운동 (선택사항)',
                  ),
                  onSaved: (value) => _category = value?.trim(),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Importance
            Card(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('중요도', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: Importance.values.map((imp) {
                        final selected = _importance == imp;
                        return ChoiceChip(
                          selected: selected,
                          label: Text(imp.name),
                          onSelected: (_) => setState(() => _importance = imp),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Progress
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '진행률',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const Spacer(),
                        Text('${(_progress * 100).round()}%'),
                      ],
                    ),
                    Slider(
                      value: _progress,
                      min: 0.0,
                      max: 1.0,
                      divisions: 20,
                      label: '${(_progress * 100).round()}%',
                      onChanged: (value) => setState(() => _progress = value),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Dates
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.flag),
                    title: const Text('시작일'),
                    trailing: Text(_formatDate(_startDate)),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _startDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2035),
                      );
                      if (date != null) {
                        setState(() {
                          _startDate = DateTime(
                            date.year,
                            date.month,
                            date.day,
                          );
                          if (_endDate.isBefore(_startDate)) {
                            _endDate = _startDate;
                          }
                        });
                      }
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.check_circle),
                    title: const Text('종료일'),
                    trailing: Text(_formatDate(_endDate)),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _endDate.isBefore(_startDate)
                            ? _startDate
                            : _endDate,
                        firstDate: _startDate,
                        lastDate: DateTime(2035),
                      );
                      if (date != null) {
                        setState(() {
                          _endDate = DateTime(date.year, date.month, date.day);
                        });
                      }
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            if (widget.todo == null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      SwitchListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                        ),
                        title: const Text('반복 설정'),
                        value: _isRepetitive,
                        onChanged: (v) {
                          setState(() {
                            _isRepetitive = v;
                            if (_isRepetitive && _repetitionDays == 0) {
                              _repetitionDays = 1;
                            } else if (!_isRepetitive) {
                              _repetitionDays = 0;
                            }
                          });
                        },
                      ),
                      AnimatedCrossFade(
                        duration: const Duration(milliseconds: 200),
                        crossFadeState: _isRepetitive
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                        firstChild: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                          child: TextFormField(
                            initialValue: _repetitionDays.toString(),
                            decoration: const InputDecoration(
                              labelText: '반복 간격 (일)',
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (_isRepetitive &&
                                  (value == null ||
                                      value.isEmpty ||
                                      int.tryParse(value) == null ||
                                      int.parse(value) <= 0)) {
                                return '유효한 반복 간격(일)을 입력해주세요.';
                              }
                              return null;
                            },
                            onSaved: (value) => _repetitionDays =
                                int.tryParse(value ?? '') ?? 0,
                            onChanged: (value) => setState(
                              () => _repetitionDays = int.tryParse(value) ?? 0,
                            ),
                          ),
                        ),
                        secondChild: const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 24),
            SafeArea(
              top: false,
              child: ElevatedButton(
                onPressed: _saveTodo,
                child: const Text('저장'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
