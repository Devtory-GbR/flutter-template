import 'package:flutter/material.dart';

class AppLocale {
  final Locale locale;
  final String desc;
  final String key;

  AppLocale({
    required this.key,
    required this.desc,
    required this.locale,
  });

  @override
  String toString() => '{key: $key, local: $locale}';
}
