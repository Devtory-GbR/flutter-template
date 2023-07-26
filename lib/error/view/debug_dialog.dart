import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DebugDialog extends StatelessWidget {
  const DebugDialog({super.key, required this.error, this.stackTrace});
  final Object error;
  final StackTrace? stackTrace;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text(AppLocalizations.of(context)!.debugTitle),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectableText(error.toString()),
          const Padding(padding: EdgeInsets.only(top: 12.0)),
          if (stackTrace != null)
            SelectableText(
              stackTrace.toString(),
              style: Theme.of(context).textTheme.bodyMedium,
            )
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppLocalizations.of(context)!.ok.toUpperCase()),
        ),
      ],
    );
  }
}
