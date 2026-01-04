import 'package:flutter/material.dart';

class TColors {
  // Main Theme Colors
  static const Color primaryColor = Color(0xFF4F46E5); // Indigo
  static const Color secondaryColor = Color(0xFF7C3AED); // Violet
  static const Color accentColor = Color(0xFFFF5722); // Deep Orange

  // App-specific Colors
  static const Color backgroundColor = Color(0xFFFFFFFF);
  static const Color textColor = Color(0xFF000000);
  static const Color todoTextColor = Colors.black87;
  static const Color doneTodoTextColor = Colors.grey;

  // Importance Colors
  static const Color highImportanceColor = Color(0xFFE53935); // Material Red
  static const Color mediumImportanceColor = secondaryColor; // Use theme secondary
  static const Color lowImportanceColor = Color(0xFF42A5F5); // Light Blue

  // UI Element Colors
  static const Color borderColor = Color(0xFFEEEEEE); // grey.shade200
  static const Color shadowColor = Colors.grey;
  static const Color dateColor = Colors.grey;
  static const Color progressIndicatorBackgroundColor = Color(0xFFE0E0E0); // grey[200]

  // Calendar Colors
  static const Color calendarMarkerColor = Color.fromARGB(255, 30, 0, 68); // Dark purple
  static const Color calendarTodayDecoration = secondaryColor;
  static const Color calendarSelectedDecoration = primaryColor;
}
