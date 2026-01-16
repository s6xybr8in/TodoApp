import 'package:flutter/material.dart';
import 'package:todo/theme/colors.dart';

class TFloatingActionButtonTheme {
  TFloatingActionButtonTheme._();

  static const lightFloatingActionButtonTheme = FloatingActionButtonThemeData(
    backgroundColor: TColors.primaryColor,
    foregroundColor: TColors.white,
    elevation: 0,
  );

  static const darkFloatingActionButtonTheme = FloatingActionButtonThemeData(
    backgroundColor: TColors.primaryColor,
    foregroundColor: TColors.white,
    elevation: 0,
  );
}
