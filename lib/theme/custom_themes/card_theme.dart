import 'package:flutter/material.dart';
import 'package:todo/theme/colors.dart';

class TCardTheme {
  TCardTheme._();

  static CardThemeData lightCardTheme = CardThemeData(
    color: TColors.white,
    surfaceTintColor: TColors.white,
    shadowColor: TColors.shadowColor,
    elevation: 0,
    margin: const EdgeInsets.symmetric(vertical: 8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: const BorderSide(color: TColors.borderColor),
    ),
    clipBehavior: Clip.antiAlias,
  );

  static CardThemeData darkCardTheme = CardThemeData(
    color: TColors.black,
    surfaceTintColor: TColors.black,
    shadowColor: TColors.grey,
    elevation: 0,
    margin: const EdgeInsets.symmetric(vertical: 8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: const BorderSide(color: TColors.grey),
    ),
    clipBehavior: Clip.antiAlias,
  );
}
