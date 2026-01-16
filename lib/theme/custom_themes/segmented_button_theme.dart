import 'package:flutter/material.dart';
import 'package:todo/theme/colors.dart';

class TSegmentedButtonTheme {
  TSegmentedButtonTheme._();

  static SegmentedButtonThemeData lightSegmentedButtonTheme = SegmentedButtonThemeData(
    style: ButtonStyle(
      textStyle: WidgetStateProperty.all(
        const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
      ),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return TColors.primaryColor;
        }
        return TColors.white; // unselected background
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return TColors.white;
        }
        return TColors.black; // unselected text/icon
      }),
      side: WidgetStateProperty.all(
        const BorderSide(color: TColors.primaryColor),
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );

  static SegmentedButtonThemeData darkSegmentedButtonTheme = SegmentedButtonThemeData(
    style: ButtonStyle(
      textStyle: WidgetStateProperty.all(
        const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
      ),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return TColors.primaryColor;
        }
        return TColors.black; // unselected background
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return TColors.white;
        }
        return TColors.white; // unselected text/icon
      }),
      side: WidgetStateProperty.all(
        const BorderSide(color: TColors.primaryColor),
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );
}
