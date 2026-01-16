import 'package:flutter/material.dart';

class QuickCategorySelect extends StatelessWidget {
  final String? selectedCategory;
  final Function(String?) onCategorySelected;

  const QuickCategorySelect({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  // 임시 카테고리 목록 (나중에 Provider 등에서 가져오도록 수정 가능)
  static const List<String> _categories = ['개인', '업무', '공부', '쇼핑', '운동'];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: () {
        _showCategoryPicker(context);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          selectedCategory ?? '카테고리 없음',
          style: textTheme.labelMedium,
        ),
      ),
    );
  }

  void _showCategoryPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.block),
                title: const Text('카테고리 없음'),
                onTap: () {
                  onCategorySelected(null);
                  Navigator.pop(context);
                },
              ),
              const Divider(height: 1),
              ..._categories.map(
                (category) => ListTile(
                  leading: const Icon(Icons.label_outline),
                  title: Text(category),
                  onTap: () {
                    onCategorySelected(category);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
