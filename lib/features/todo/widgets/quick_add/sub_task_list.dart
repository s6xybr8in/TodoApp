import 'package:flutter/material.dart';

class SubTaskList extends StatelessWidget {
  final List<TextEditingController> controllers;
  final Function(int) onRemove;

  const SubTaskList({
    super.key,
    required this.controllers,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: controllers.asMap().entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            children: [
              Icon(
                Icons.radio_button_unchecked,
                size: 20,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: entry.value,
                  decoration: const InputDecoration(
                    hintText: '하위 작업을 입력하세요',
                    border: InputBorder.none,
                    isDense: true,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.close,
                  size: 16,
                  color: colorScheme.onSurfaceVariant,
                ),
                onPressed: () => onRemove(entry.key),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
