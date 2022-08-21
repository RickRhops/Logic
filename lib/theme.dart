import 'package:flutter/material.dart';


abstract class AppColors {
  //color values
  static const black = Color(0xFF000000);
  static const darkGray = Color(0xFF444444);
  static const lightGray = Color(0xFF888888);
  static const white = Color(0xFFEEEEEE);
  static const red = Color(0xFFEE0000);

  //color elements
  static const background = AppColors.black;
  static const noteCardText = AppColors.white;
  static const noteCardBorder = AppColors.darkGray;  
  static const newNoteInputFieldText = AppColors.white;
  static const newNoteInputFieldHint = AppColors.lightGray;
  static const cursorColor = AppColors.white;
  static const secondaryText = AppColors.lightGray;
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