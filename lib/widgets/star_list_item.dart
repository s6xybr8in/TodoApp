import 'package:flutter/material.dart';
import 'package:todo/models/importance.dart';
import 'package:todo/models/star.dart';
import 'package:todo/repositories/star_repository.dart';
import 'package:todo/theme/colors.dart';

class StarListItem extends StatelessWidget {
  final Star star;
  final VoidCallback onTap;
  final _starRepository = StarRepository();

  StarListItem({
    super.key,
    required this.star,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: TColors.backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: TColors.borderColor),
          boxShadow: [
            BoxShadow(
              color: TColors.shadowColor,
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon : const Icon(Icons.star),
                  color: Colors.amber,

                  onPressed: () async{
                    await _starRepository.cascadeTodoDelete(star);
                  },
                ),
                Expanded(
                  child: Text(
                    star.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Chip(
                    label: Text(
                      star.importance.name.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        color: _getImportanceColor(star.importance),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // backgroundColor: _getImportanceColor(todo.importance),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    visualDensity: VisualDensity.compact,
                  ),
                  const Spacer(),]))])));}




  Color _getImportanceColor(Importance importance) {
    switch (importance) {
      case Importance.high:
        return TColors.highImportanceColor;
      case Importance.medium:
        return TColors.mediumImportanceColor;
      case Importance.low:
        return TColors.lowImportanceColor;
    }
  }
}