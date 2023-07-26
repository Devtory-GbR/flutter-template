import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:repositories/repositories.dart';

class ErrorTranslation {
  final String title;
  final String text;

  ErrorTranslation._({required this.title, required this.text});

  factory ErrorTranslation.fromError(Object error, BuildContext context) {
    if (error is HttpException) {
      if (error.statusCode != null &&
          error.statusCode! >= 400 &&
          error.statusCode! < 500) {
        return ErrorTranslation._(
            title: AppLocalizations.of(context)!.errorHttpTitle,
            text: AppLocalizations.of(context)!.errorHttp);
      }

      if (error.statusCode != null &&
          error.statusCode! >= 500 &&
          error.statusCode! < 600) {
        return ErrorTranslation._(
            title: AppLocalizations.of(context)!.errorServer,
            text: AppLocalizations.of(context)!.errorServerTitle);
      }
    }

    // When a client exception it thrown it is usally a problem with the network
    if (error is ClientException) {
      return ErrorTranslation._(
          title: AppLocalizations.of(context)!.errorNetworkTitle,
          text: AppLocalizations.of(context)!.errorNetwork);
    }

    return ErrorTranslation._(
        title: AppLocalizations.of(context)!.errorTitle,
        text: AppLocalizations.of(context)!.error);
  }
}
