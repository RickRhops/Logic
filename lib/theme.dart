import 'package:flutter/material.dart';


abstract class AppColors {
  //color values
  static const black = Color(0xFF000000);
  static const gray = Color(0xFF565656);
  static const white = Color(0xFFE6E6EB);
  static const red = Color(0xFFff453a);

  //color elements
  static const background = AppColors.black;
  static const noteCardText = AppColors.white;
  static const noteCardBorder = AppColors.gray;  
  static const newNoteInputFieldText = AppColors.white;
  static const newNoteInputFieldHint = AppColors.gray;
  static const cursorColor = AppColors.white;
  static const secondaryText = AppColors.gray;
  static const supportDanger = AppColors.red;
}

abstract class AppTheme {
  static final visualDensity = VisualDensity.adaptivePlatformDensity;

  static ThemeData theme() => ThemeData(
    brightness: Brightness.dark,
    visualDensity: visualDensity,

    backgroundColor: AppColors.background,
    scaffoldBackgroundColor: AppColors.background,
    fontFamily: 'BIZ UDMincho',
  );
}