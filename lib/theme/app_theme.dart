import 'package:flutter/material.dart';

class AppTheme {
  // 보라색 시드 컬러
  static const Color primarySeedColor = Color(0xFF7C3AED);
  static const Color surfaceColor = Color(0xFFFAFAFA);

  // Light ColorScheme
  static final ColorScheme lightColorScheme = ColorScheme.fromSeed(
    seedColor: primarySeedColor,
    brightness: Brightness.light,
    surface: surfaceColor,
  );

  // Dark ColorScheme
  static final ColorScheme darkColorScheme = ColorScheme.fromSeed(
    seedColor: primarySeedColor,
    brightness: Brightness.dark,
  );

  // Base Theme 생성 함수
  static ThemeData _baseTheme(ColorScheme scheme) => ThemeData(
    fontFamily: 'Pretendard',
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: scheme.surface,
    appBarTheme: AppBarTheme(
      elevation: 0.5,
      backgroundColor: scheme.surface,
      foregroundColor: scheme.onSurface,
      centerTitle: true,
      scrolledUnderElevation: 0,
      toolbarHeight: 56,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: scheme.onSurface,
        letterSpacing: 0,
      ),
    ),
    cardTheme: CardThemeData(
      color: scheme.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: scheme.surfaceVariant,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: scheme.outlineVariant),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: scheme.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: scheme.primary, width: 2),
      ),
      labelStyle: TextStyle(color: scheme.onSurfaceVariant),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: scheme.primary,
      foregroundColor: scheme.onPrimary,
    ),
    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      side: BorderSide(color: scheme.outlineVariant),
      selectedColor: scheme.primaryContainer,
    ),
    sliderTheme: const SliderThemeData(
      showValueIndicator: ShowValueIndicator.onlyForDiscrete,
    ),
  );

  // Light Theme
  static ThemeData get lightTheme => _baseTheme(lightColorScheme);

  // Dark Theme
  static ThemeData get darkTheme => _baseTheme(darkColorScheme);
}
