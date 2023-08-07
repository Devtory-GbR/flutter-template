import 'package:flutter/material.dart';

class CustomColor extends ColorSwatch<String> {
  const CustomColor(super.primary, super.swatch);

  Color get color => this['color']!;
  Color get textColor => this['text']!;
}

class AppColors {
  AppColors._({
    required this.primaryColor,
    required this.accentColor,
    required this.customColors,
  });

  final MaterialColor primaryColor;
  final MaterialAccentColor accentColor;
  final Map<String, CustomColor> customColors;

  static const int _primaryLight = 0xFFFF847C;

  static const MaterialColor primaryLight = MaterialColor(
    _primaryLight,
    <int, Color>{
      50: Color(0xFFFFF0EF),
      100: Color(0xFFFFDAD8),
      200: Color(0xFFFFC2BE),
      300: Color(0xFFFFA9A3),
      400: Color(0xFFFF9690),
      500: Color(_primaryLight),
      600: Color(0xFFFF7C74),
      700: Color(0xFFFF7169),
      800: Color(0xFFFF675F),
      900: Color(0xFFFF544C),
    },
  );

  static const int _accentLight = 0xFF7871C2;

  static const MaterialAccentColor accentLight = MaterialAccentColor(
    _accentLight,
    <int, Color>{
      100: Color(0xFFD0CEEA),
      200: Color(_accentLight),
      400: Color(0xFF524AAC),
      700: Color(0xFF3E3781),
    },
  );

  static const int _primaryDark = 0xFFFF847C;

  static const MaterialColor primaryDark = MaterialColor(
    _primaryDark,
    <int, Color>{
      50: Color(0xFFFFF0EF),
      100: Color(0xFFFFDAD8),
      200: Color(0xFFFFC2BE),
      300: Color(0xFFFFA9A3),
      400: Color(0xFFFF9690),
      500: Color(_primaryDark),
      600: Color(0xFFFF7C74),
      700: Color(0xFFFF7169),
      800: Color(0xFFFF675F),
      900: Color(0xFFFF544C),
    },
  );

  static const int _accentDark = 0xFF7871C2;

  static const MaterialAccentColor accentDark = MaterialAccentColor(
    _accentDark,
    <int, Color>{
      100: Color(0xFFD0CEEA),
      200: Color(_accentDark),
      400: Color(0xFF524AAC),
      700: Color(0xFF3E3781),
    },
  );

  static const Map<String, CustomColor> customColorsLight =
      <String, CustomColor>{
    'grey': CustomColor(
      0xFF95a5a6,
      <String, Color>{'color': Color(0xFF95a5a6), 'text': Colors.white},
    ),
    'blue': CustomColor(
      0xFF3498db,
      <String, Color>{'color': Color(0xFF3498db), 'text': Colors.white},
    ),
    'green': CustomColor(
      0xFF2ecc71,
      <String, Color>{'color': Color(0xFF2ecc71), 'text': Colors.white},
    ),
    'yellow': CustomColor(
      0xFFf1c40f,
      <String, Color>{'color': Color(0xFFf1c40f), 'text': Colors.white},
    ),
    'orange': CustomColor(
      0xFFe67e22,
      <String, Color>{'color': Color(0xFFe67e22), 'text': Colors.white},
    ),
    'red': CustomColor(
      0xFFe74c3c,
      <String, Color>{'color': Color(0xFFe74c3c), 'text': Colors.white},
    ),
  };

  static const Map<String, CustomColor> customColorsDark =
      <String, CustomColor>{
    'grey': CustomColor(
      0xFF7f8c8d,
      <String, Color>{'color': Color(0xFF7f8c8d), 'text': Colors.white},
    ),
    'blue': CustomColor(
      0xFF2980b9,
      <String, Color>{'color': Color(0xFF2980b9), 'text': Colors.white},
    ),
    'green': CustomColor(
      0xFF27ae60,
      <String, Color>{'color': Color(0xFF27ae60), 'text': Colors.white},
    ),
    'yellow': CustomColor(
      0xFFf39c12,
      <String, Color>{'color': Color(0xFFf39c12), 'text': Colors.white},
    ),
    'orange': CustomColor(
      0xFFd35400,
      <String, Color>{'color': Color(0xFFd35400), 'text': Colors.white},
    ),
    'red': CustomColor(
      0xFFc0392b,
      <String, Color>{'color': Color(0xFFc0392b), 'text': Colors.white},
    ),
  };

  static AppColors of(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.dark) {
      return AppColors._(
        primaryColor: primaryDark,
        accentColor: accentDark,
        customColors: customColorsDark,
      );
    } else {
      return AppColors._(
        primaryColor: primaryLight,
        accentColor: accentLight,
        customColors: customColorsLight,
      );
    }
  }

  CustomColor get fineColor => customColors['green']!;
  CustomColor get debugColor => customColors['grey']!;
  CustomColor get infoColor => customColors['blue']!;
  CustomColor get warningColor => customColors['yellow']!;
  CustomColor get errorColor => customColors['orange']!;
  CustomColor get criticalColor => customColors['red']!;
}
