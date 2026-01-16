import 'package:flutter/material.dart';
import 'package:todo/theme/colors.dart';
import 'package:todo/theme/custom_themes/app_bar_theme.dart';
import 'package:todo/theme/custom_themes/bottom_navigation_bar_theme.dart';
import 'package:todo/theme/custom_themes/bottom_sheet_theme.dart';
import 'package:todo/theme/custom_themes/card_theme.dart';
import 'package:todo/theme/custom_themes/checkbox_theme.dart';
import 'package:todo/theme/custom_themes/chip_theme.dart';
import 'package:todo/theme/custom_themes/elevated_button_theme.dart';
import 'package:todo/theme/custom_themes/floating_action_button_theme.dart';
import 'package:todo/theme/custom_themes/input_decoration_theme.dart';
import 'package:todo/theme/custom_themes/outlined_button_theme.dart';
import 'package:todo/theme/custom_themes/segmented_button_theme.dart';
import 'package:todo/theme/custom_themes/text_theme.dart';

class TAppTheme {
  TAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Pretendard',
    brightness: Brightness.light,
    primaryColor: TColors.primaryColor,
    textTheme: TTextTheme.lightTextTheme,
    chipTheme: TChipTheme.lightChipTheme,
    cardTheme: TCardTheme.lightCardTheme,
    scaffoldBackgroundColor: TColors.backgroundColor,
    appBarTheme: TAppBarTheme.lightAppBarTheme,
    checkboxTheme: TCheckboxTheme.lightCheckboxTheme,
    bottomNavigationBarTheme:
        TBottomNavigationBarTheme.lightBottomNavigationBarTheme,
    floatingActionButtonTheme:
        TFloatingActionButtonTheme.lightFloatingActionButtonTheme,
    bottomSheetTheme: TBottomSheetTheme.lightBottomSheetTheme,
    elevatedButtonTheme: TElevatedButtonTheme.lightElevatedButtonTheme,
    segmentedButtonTheme: TSegmentedButtonTheme.lightSegmentedButtonTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: TInputDecorationTheme.lightInputDecorationTheme,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Pretendard',
    brightness: Brightness.dark,
    primaryColor: TColors.primaryColor,
    textTheme: TTextTheme.darkTextTheme,
    chipTheme: TChipTheme.darkChipTheme,
    cardTheme: TCardTheme.darkCardTheme,
    scaffoldBackgroundColor: TColors.black, // Dark mode background might vary
    appBarTheme: TAppBarTheme.darkAppBarTheme,
    checkboxTheme: TCheckboxTheme.darkCheckboxTheme,
    bottomNavigationBarTheme:
        TBottomNavigationBarTheme.darkBottomNavigationBarTheme,
    floatingActionButtonTheme:
        TFloatingActionButtonTheme.darkFloatingActionButtonTheme,
    bottomSheetTheme: TBottomSheetTheme.darkBottomSheetTheme,
    elevatedButtonTheme: TElevatedButtonTheme.darkElevatedButtonTheme,
    segmentedButtonTheme: TSegmentedButtonTheme.darkSegmentedButtonTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.darkOutlinedButtonTheme,
    inputDecorationTheme: TInputDecorationTheme.darkInputDecorationTheme,
  );
}
