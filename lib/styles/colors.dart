import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const MaterialColor primary = MaterialColor(
    _primaryValue,
    <int, Color>{
      50: Color(0xFFFFF0EF),
      100: Color(0xFFFFDAD8),
      200: Color(0xFFFFC2BE),
      300: Color(0xFFFFA9A3),
      400: Color(0xFFFF9690),
      500: Color(_primaryValue),
      600: Color(0xFFFF7C74),
      700: Color(0xFFFF7169),
      800: Color(0xFFFF675F),
      900: Color(0xFFFF544C),
    },
  );

  static const int _primaryValue = 0xFFFF847C;

  static const MaterialAccentColor accent = MaterialAccentColor(
    _accent,
    <int, Color>{
      100: Color(0xFFD0CEEA),
      200: Color(_accent),
      400: Color(0xFF524AAC),
      700: Color(0xFF3E3781),
    },
  );

  static const int _accent = 0xFF7871C2;

  static const MaterialColor primaryDark = MaterialColor(
    _primaryValueDark,
    <int, Color>{
      50: Color(0xFFFFF0EF),
      100: Color(0xFFFFDAD8),
      200: Color(0xFFFFC2BE),
      300: Color(0xFFFFA9A3),
      400: Color(0xFFFF9690),
      500: Color(_primaryValueDark),
      600: Color(0xFFFF7C74),
      700: Color(0xFFFF7169),
      800: Color(0xFFFF675F),
      900: Color(0xFFFF544C),
    },
  );

  static const int _primaryValueDark = 0xFFFF847C;

  static const MaterialAccentColor accentDark = MaterialAccentColor(
    _accentDark,
    <int, Color>{
      100: Color(0xFFD0CEEA),
      200: Color(_accentDark),
      400: Color(0xFF524AAC),
      700: Color(0xFF3E3781),
    },
  );

  static const int _accentDark = 0xFF7871C2;
}
