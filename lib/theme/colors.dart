import 'package:flutter/material.dart';

class TColors {
  // Main Theme Colors - 푸른 바다 계열
  static const Color primaryColor = Color(0xFF0EA5E9); // 맑은 바다색 (Sky 500)
  static const Color secondaryColor = Color(0xFF0284C7); // 깊은 바다색 (Sky 600)
  static const Color accentColor = Color(0xFF7DD3FC); // 얕은 바다색 (Sky 300)

  // App-specific Colors
  static const Color backgroundColor = Color(0xFFF0F9FF); // 아주 옅은 하늘색 배경 (Sky 50)
  static const Color textColor = Color(0xFF0C4A6E); // 짙은 남색 텍스트 (Sky 900)
  static const Color todoTextColor = Color(0xFF0F172A); // Slate 900
  static const Color doneTodoTextColor = Color(0xFF94A3B8); // Slate 400

  // Importance Colors - 파란색 톤
  static const Color highImportanceColor = Color(0xFF0284C7); // Sky 600
  static const Color mediumImportanceColor = Color(0xFF38BDF8); // Sky 400
  static const Color lowImportanceColor = Color(0xFFBAE6FD); // Sky 200

  // UI Element Colors
  static const Color borderColor = Color(0xFFE0F2FE); // Sky 100
  static const Color shadowColor = Color(0xFFE5E7EB);
  static const Color dateColor = Color(0xFF64748B); // Slate 500
  static const Color progressIndicatorBackgroundColor = Color(0xFFE0E0E0);

  // Calendar Colors
  static const Color calendarMarkerColor = Color(0xFF0284C7); // Sky 600
  static const Color calendarTodayDecoration = Color(0xFF0EA5E9); // Sky 500
  static const Color calendarSelectedDecoration = Color(0xFF7DD3FC); // Sky 300

  // Neutral Colors
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey = Colors.grey;
  static const Color transparent = Colors.transparent;
  static const Color error = Color(0xFFD32F2F); // Red 700
}
