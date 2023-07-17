import 'package:flutter/material.dart';

class HomeMenuItem {
  final String labelKey;
  final IconData iconData;

  HomeMenuItem({required this.labelKey, required this.iconData});

  @override
  String toString() => '{labelKey: $labelKey}';
}
