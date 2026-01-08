import 'package:flutter/material.dart';

// 보라색 그래디언트 AppBar
const kAppBarDecoration = BoxDecoration(
  gradient: LinearGradient(
    colors: [
      Color(0xFF7C3AED), // 보라색
      Color(0xFFA78BFA), // 밝은 보라
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
);

// 대체: 진한 보라색 버전
const kAppBarDecorationDark = BoxDecoration(
  gradient: LinearGradient(
    colors: [
      Color(0xFF6D28D9), // 진한 보라
      Color(0xFF7C3AED), // 보라
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
);
