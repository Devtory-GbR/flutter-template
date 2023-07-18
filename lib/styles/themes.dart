import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/styles/colors.dart';

class AppThemes {
  AppThemes._();

  // feel free to change the theme or just add new one
  // dont't forget to add it to the theme_cubit.dart
  static final primary = ThemeData(
    brightness: Brightness.light,
    primarySwatch: AppColors.primary,
    colorScheme: ColorScheme.fromSwatch(primarySwatch: AppColors.primary)
        .copyWith(secondary: AppColors.accent),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: AppColors.primary,
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.white70,
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark),
      titleTextStyle: TextStyle(
        color: AppColors.primary,
        fontFamily: "Clicker Script",
        fontSize: 41,
      ),
    ),
    cardTheme: const CardTheme(
      margin: EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
    ),
    dividerTheme: const DividerThemeData(indent: 48.0, space: 1.0),
  );

  static final primaryDarkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: AppColors.primary,
    colorScheme: ColorScheme.fromSwatch(primarySwatch: AppColors.primary)
        .copyWith(secondary: AppColors.accent, brightness: Brightness.dark),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black12,
      foregroundColor: Colors.white,
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.black26,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light),
      titleTextStyle: TextStyle(
        fontFamily: "Clicker Script",
        fontSize: 41,
      ),
    ),
    cardTheme: const CardTheme(
      margin: EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
    ),
    dividerTheme: const DividerThemeData(indent: 48.0, space: 1.0),
    snackBarTheme: const SnackBarThemeData(
        contentTextStyle: TextStyle(color: Colors.white)),
  );
}
