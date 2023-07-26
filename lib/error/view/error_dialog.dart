import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:myapp/error/error.dart';
import 'package:myapp/error/model/error_translation.dart';

class ErrorDialog extends StatelessWidget {
  const ErrorDialog({super.key, required this.error, this.stackTrace});

  final Object error;
  final StackTrace? stackTrace;

  @override
  Widget build(BuildContext context) {
    final errorTranslation = ErrorTranslation.fromError(error, context);
    return AlertDialog(
      title: Text(errorTranslation.title),
      content: Text(errorTranslation.text),
      actions: [
        TextButton(
          onPressed: () => showDebugDialog(
            context: context,
            error: error,
            stackTrace: stackTrace,
          ),
          child: Text(AppLocalizations.of(context)!.help),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppLocalizations.of(context)!.ok.toUpperCase()),
        ),
      ],
    );
  }
}
