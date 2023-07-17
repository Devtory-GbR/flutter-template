import 'package:flutter/material.dart';

class AppTheme {
  final ThemeData theme;
  final String desc;
  final String key;

  AppTheme({
    required this.key,
    required this.desc,
    required this.theme,
  });

  @override
  String toString() => '{key: $key}';
}
