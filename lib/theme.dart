import 'package:flutter/material.dart';


abstract class AppColors {
  //color values
  static const black = Color(0xFF000000);
  static const gray1 = Color(0xFF040406);
  static const gray2 = Color(0xFF141416);
  static const gray3 = Color(0xFF242426);
  static const gray4 = Color(0xFF545456);
  static const gray5 = Color(0xFFB1B1B6);
  static const gray6 = Color(0xFFE5E5EA);
  static const gray7 = Color(0xFFF1F1F7);

  //color elements
  static const background = AppColors.gray1;
  static const topBarBorder = AppColors.gray3;
  static const topBarBackground = AppColors.black;
  static const noteCard = AppColors.gray2;
  static const noteCardText = AppColors.gray7;
  static const newNoteInputBar = AppColors.gray2;
  static const newNoteInputFieldText = AppColors.gray7;
  static const newNoteInputBorder = AppColors.gray4;
  static const newNoteInputFieldHint = AppColors.gray4;
  static const newNoteInputIcon = AppColors.gray5;

}

abstract class AppTheme {
  static final visualDensity = VisualDensity.adaptivePlatformDensity;

  static ThemeData theme() => ThemeData(
    brightness: Brightness.dark,
    visualDensity: visualDensity,

    backgroundColor: AppColors.background,
    scaffoldBackgroundColor: AppColors.background,
    fontFamily: 'IBM Plex Sans',

    snackBarTheme: const SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      elevation: 0,
      backgroundColor: AppColors.gray3,
      contentTextStyle: TextStyle(
        color: AppColors.gray6,
        fontSize: 14,
      ),
    ),
  );
}