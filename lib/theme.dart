import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


abstract class AppColors {
  //color values
  static const black = Color(0xFF000000);
  static const gray1 = Color(0xFF040406); // 10
  static const gray2 = Color(0xFF141416); // 20
  static const gray3 = Color(0xFF242426); // 30
  static const gray4 = Color(0xFF545456); // 50
  static const gray5 = Color(0xFFB1B1B6); // 80
  static const gray6 = Color(0xFFE5E5EA); // 90
  static const gray7 = Color(0xFFF1F1F7); // 100


  static const gray10 = Color(0xFF0A0A0C);
  static const gray20 = Color(0xFF141416);
  static const gray30 = Color(0xFF28282A);
  static const gray40 = Color(0xFF3C3C3E);
  static const gray50 = Color(0xFF505052);
  static const gray60 = Color(0xFF646469);
  static const gray70 = Color(0xFF96969B);
  static const gray80 = Color(0xFFBEBEC3);
  static const gray90 = Color(0xFFE6E6EB);
  static const gray100 = Color(0xFFF0F0F5);
  static const red = Color(0xFFff453a);


  //color elements
  static const background = AppColors.black;
  static const topBarBackground = AppColors.black;
  static const noteCard = AppColors.gray20;
  static const noteCardText = AppColors.gray90;
  static const newNoteInputBar = AppColors.gray20;
  static const newNoteInputFieldText = AppColors.gray90;
  static const newNoteInputFieldHint = AppColors.gray60;
  static const cursorColor = AppColors.gray80;
  static const snackBar = AppColors.black;
  static const snackBarText = AppColors.gray70;
  static const supportDanger = AppColors.red;
  static const alertDialog = AppColors.gray20;
  static const alertDialogText = AppColors.gray80;
}

abstract class AppTheme {
  static final visualDensity = VisualDensity.adaptivePlatformDensity;

  static ThemeData theme() => ThemeData(
    brightness: Brightness.dark,
    visualDensity: visualDensity,

    backgroundColor: AppColors.background,
    scaffoldBackgroundColor: AppColors.background,
    fontFamily: 'BIZ UDMincho',

    snackBarTheme: const SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.snackBar,
      contentTextStyle: TextStyle(
        color: AppColors.snackBarText,
        fontSize: 16,
        fontFamily: 'BIZ UDMincho',
      ),
    ),

    dialogTheme: const DialogTheme(
      backgroundColor: AppColors.alertDialog,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.zero)),
      elevation: 0,
      titleTextStyle: TextStyle(
        fontFamily: 'BIZ UDMincho',
        fontSize: 16,
        color: AppColors.alertDialogText,
      ),
      contentTextStyle: TextStyle(color: AppColors.alertDialogText),
    )
  );
}