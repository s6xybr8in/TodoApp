import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/features/todo/widgets/quick_add/date_repetition_picker.dart';
import 'package:todo/features/todo/widgets/quick_add/quick_category_select.dart';
import 'package:todo/features/todo/widgets/quick_add/sub_task_list.dart';
import 'package:todo/models/importance.dart';
import 'package:todo/models/repetition.dart';
import 'package:todo/providers/repetition_provider.dart';
import 'package:todo/providers/todo_provider.dart';

class QuickAddTodoSheet extends StatefulWidget {
  const QuickAddTodoSheet({super.key});

  @override
  State<QuickAddTodoSheet> createState() => _QuickAddTodoSheetState();
}

class _QuickAddTodoSheetState extends State<QuickAddTodoSheet> {
  final TextEditingController _titleController = TextEditingController();
  final FocusNode _titleFocusNode = FocusNode();
  DateTime _selectedDate = DateTime.now();
  String? _selectedCategory;
  RepeatType? _selectedRepeatType;

  // 하위 작업(서브태스크) 입력을 위한 리스트
  final List<TextEditingController> _subTaskControllers = [];

  @override
  void initState() {
    super.initState();
    // 화면이 뜨자마자 키보드 올라오게 설정
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_titleFocusNode);
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _titleFocusNode.dispose();
    for (var controller in _subTaskControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addSubTaskField() {
    setState(() {
      _subTaskControllers.add(TextEditingController());
    });
  }

  Future<void> _submit() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    final todoProvider = context.read<TodoProvider>();
    final repetitionProvider = context.read<RepetitionProvider>();

    // 1. 메인 투두 생성
    final newTodo = todoProvider.makeTodo(
      title: title,
      importance: Importance.medium,
      endDate: _selectedDate,
      category: _selectedCategory,
    );

    if (_selectedRepeatType != null) {
      final repetition = Repetition(id: newTodo.id, type: _selectedRepeatType!);
      await repetitionProvider.addRepetition(repetition);
      newTodo.repetitionId = repetition.id;
    }

    await todoProvider.addTodo(newTodo);

    for (var controller in _subTaskControllers) {
      final subTaskTitle = controller.text.trim();
      if (subTaskTitle.isEmpty) continue;
      final subTask = todoProvider.makeTodo(
        title: subTaskTitle,
        importance: Importance.medium,
        category: _selectedCategory,
        endDate: _selectedDate,
        parentId: newTodo.id,
      );
      newTodo.childrenIds.add(subTask.id);
      await todoProvider.addTodo(subTask);
      await todoProvider.updateTodo(newTodo); // 자식 ID들 업데이트
    }
    if (mounted) {
      Navigator.pop(context); // 시트 닫기
    }
  }

  void _openDateAndRepetitionPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DateRepetitionPicker(
          initialDate: _selectedDate,
          initialRepeatType: _selectedRepeatType,
          onDateChanged: (date) {
            setState(() => _selectedDate = date);
          },
          onRepeatTypeChanged: (type) {
            setState(() => _selectedRepeatType = type);
          },
          onConfirm: () {
            Navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // 키보드 높이만큼 패딩을 주어 가려지지 않게 함
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.fromLTRB(16, 16, 16, bottomPadding + 16),
      decoration: BoxDecoration(
        color: Theme.of(context).bottomSheetTheme.backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // 내용물만큼만 높이 차지
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. 메인 입력창
          TextField(
            controller: _titleController,
            focusNode: _titleFocusNode,
            decoration: InputDecoration(
              hintText: '여기에 새 작업을 입력하세요',
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              hintStyle: textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
            style: textTheme.titleMedium,
            onSubmitted: (_) => _submit(), // 엔터 치면 저장
          ),

          const SizedBox(height: 12),

          // 2. 하위 작업 입력창들 (동적 추가)
          SubTaskList(
            controllers: _subTaskControllers,
            onRemove: (index) {
              setState(() {
                _subTaskControllers[index].dispose();
                _subTaskControllers.removeAt(index);
              });
            },
          ),

          // 하위 작업 추가 버튼 역할 (입력창에 포커스 갔을 때만 보여주거나 할 수도 있음)
          // 여기서는 생략하고 UI 하단 바 구성
          const Divider(),

          // 3. 하단 도구 모음 (카테고리, 날짜, 보내기)
          Row(
            children: [
              // 카테고리 버튼
              QuickCategorySelect(
                selectedCategory: _selectedCategory,
                onCategorySelected: (category) {
                  setState(() {
                    _selectedCategory = category;
                  });
                },
              ),

              const SizedBox(width: 12),

              // 날짜 선택 및 반복 설정 아이콘
              IconButton(
                icon: Icon(
                  _selectedRepeatType != null
                      ? Icons.repeat
                      : Icons.calendar_today_outlined,
                  size: 20,
                  color: colorScheme.primary,
                ),
                onPressed: _openDateAndRepetitionPicker,
                tooltip: '기한 및 반복 설정',
              ),

              // 하위 작업 추가 아이콘 (선택 사항)
              IconButton(
                icon: Icon(
                  Icons.account_tree_outlined,
                  size: 22,
                  color: colorScheme.onSurfaceVariant,
                ),
                onPressed: _addSubTaskField,
                tooltip: '하위 작업 추가',
              ),

              const Spacer(),

              // 저장 버튼
              CircleAvatar(
                backgroundColor: colorScheme.primary,
                radius: 20,
                child: IconButton(
                  icon: Icon(Icons.arrow_upward, color: colorScheme.onPrimary),
                  onPressed: _submit,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
