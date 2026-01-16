import 'package:flutter/material.dart';

class TodoExpandButton extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onPressed;

  const TodoExpandButton({
    super.key,
    required this.isExpanded,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        isExpanded ? Icons.expand_less : Icons.expand_more,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      visualDensity: VisualDensity.compact,
    );
  }
}
