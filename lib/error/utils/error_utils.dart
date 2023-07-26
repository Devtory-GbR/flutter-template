import 'package:flutter/material.dart';
import 'package:myapp/error/error.dart';

Future<void> showErrorDialog({
  required BuildContext context,
  required Object error,
  StackTrace? stackTrace,
}) {
  return showDialog<void>(
    barrierDismissible: false,
    context: context,
    builder: (context) => ErrorDialog(
      error: error,
      stackTrace: stackTrace,
    ),
  );
}

Future<void> showDebugDialog({
  required BuildContext context,
  required Object error,
  StackTrace? stackTrace,
}) {
  return showDialog<void>(
    barrierDismissible: false,
    context: context,
    builder: (context) => DebugDialog(
      error: error,
      stackTrace: stackTrace,
    ),
  );
}
