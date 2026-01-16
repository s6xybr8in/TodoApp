import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/models/repetition.dart';

class DateRepetitionPicker extends StatefulWidget {
  final DateTime initialDate;
  final RepeatType? initialRepeatType;
  final Function(DateTime) onDateChanged;
  final Function(RepeatType?) onRepeatTypeChanged;
  final VoidCallback onConfirm;

  const DateRepetitionPicker({
    super.key,
    required this.initialDate,
    required this.initialRepeatType,
    required this.onDateChanged,
    required this.onRepeatTypeChanged,
    required this.onConfirm,
  });

  @override
  State<DateRepetitionPicker> createState() => _DateRepetitionPickerState();
}

class _DateRepetitionPickerState extends State<DateRepetitionPicker> {
  late DateTime _selectedDate;
  late RepeatType? _selectedRepeatType;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _selectedRepeatType = widget.initialRepeatType;
  }

  Widget _buildDateOption(BuildContext context, String label, DateTime date) {
    final isSelected = _isSameDay(_selectedDate, date);
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (val) {
        if (val) {
          setState(() => _selectedDate = date);
          widget.onDateChanged(date);
        }
      },
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('기한 설정', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildDateOption(context, '오늘', DateTime.now()),
                  const SizedBox(width: 8),
                  _buildDateOption(
                    context,
                    '내일',
                    DateTime.now().add(const Duration(days: 1)),
                  ),
                  const SizedBox(width: 8),
                  _buildDateOption(
                    context,
                    '다음주',
                    DateTime.now().add(const Duration(days: 7)),
                  ),
                  const SizedBox(width: 8),
                  ActionChip(
                    label: Text(DateFormat('M/d').format(_selectedDate)),
                    avatar: const Icon(Icons.calendar_today, size: 16),
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2035),
                      );
                      if (date != null) {
                        setState(() => _selectedDate = date);
                        widget.onDateChanged(date);
                      }
                    },
                  ),
                ],
              ),
            ),
            const Divider(height: 32),
            Text('반복 설정', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('반복 안함'),
                  selected: _selectedRepeatType == null,
                  onSelected: (val) {
                    if (val) {
                      setState(() => _selectedRepeatType = null);
                      widget.onRepeatTypeChanged(null);
                    }
                  },
                ),
                ChoiceChip(
                  label: const Text('매일'),
                  selected: _selectedRepeatType == RepeatType.daily,
                  onSelected: (val) {
                    if (val) {
                      setState(() => _selectedRepeatType = RepeatType.daily);
                      widget.onRepeatTypeChanged(RepeatType.daily);
                    }
                  },
                ),
                ChoiceChip(
                  label: const Text('매주'),
                  selected: _selectedRepeatType == RepeatType.weekly,
                  onSelected: (val) {
                    if (val) {
                      setState(() => _selectedRepeatType = RepeatType.weekly);
                      widget.onRepeatTypeChanged(RepeatType.weekly);
                    }
                  },
                ),
                ChoiceChip(
                  label: const Text('매월'),
                  selected: _selectedRepeatType == RepeatType.monthly,
                  onSelected: (val) {
                    if (val) {
                      setState(() => _selectedRepeatType = RepeatType.monthly);
                      widget.onRepeatTypeChanged(RepeatType.monthly);
                    }
                  },
                ),
                ChoiceChip(
                  label: const Text('매년'),
                  selected: _selectedRepeatType == RepeatType.yearly,
                  onSelected: (val) {
                    if (val) {
                      setState(() => _selectedRepeatType = RepeatType.yearly);
                      widget.onRepeatTypeChanged(RepeatType.yearly);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: widget.onConfirm,
                child: const Text('확인'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
