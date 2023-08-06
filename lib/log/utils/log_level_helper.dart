import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:myapp/styles/colors.dart';

CustomColor getLevelColor(int level, BuildContext context) {
  if (level <= Level.FINE.value) {
    return AppColors.of(context).fineColor;
  } else if (level <= Level.CONFIG.value) {
    return AppColors.of(context).debugColor;
  } else if (level <= Level.INFO.value) {
    return AppColors.of(context).infoColor;
  } else if (level <= Level.WARNING.value) {
    return AppColors.of(context).warningColor;
  } else if (level <= Level.SEVERE.value) {
    return AppColors.of(context).errorColor;
  } else if (level <= Level.SHOUT.value) {
    return AppColors.of(context).criticalColor;
  } else {
    return AppColors.of(context).debugColor;
  }
}

String getLevelText(int level) {
  if (level <= Level.FINE.value) {
    return 'FINE';
  } else if (level <= Level.CONFIG.value) {
    return 'CONFIG';
  } else if (level <= Level.INFO.value) {
    return 'INFO';
  } else if (level <= Level.WARNING.value) {
    return 'WARNING';
  } else if (level <= Level.SEVERE.value) {
    return 'SERVERE';
  } else if (level <= Level.SHOUT.value) {
    return 'SHOUT';
  } else {
    return 'LOG';
  }
}

IconData getLevelIcon(int level) {
  if (level <= Level.FINE.value) {
    return Icons.check;
  } else if (level <= Level.CONFIG.value) {
    return Icons.bug_report;
  } else if (level <= Level.INFO.value) {
    return Icons.info;
  } else if (level <= Level.WARNING.value) {
    return Icons.warning;
  } else if (level <= Level.SEVERE.value) {
    return Icons.error;
  } else if (level <= Level.SHOUT.value) {
    return Icons.emergency;
  } else {
    return Icons.summarize;
  }
}
