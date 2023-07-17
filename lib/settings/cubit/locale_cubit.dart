import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:myapp/settings/settings.dart';
import 'package:repositories/repositories.dart';

class LocaleCubit extends Cubit<AppLocale> {
  LocaleCubit({required LocalPersistence localePersistence})
      : _localePersistence = localePersistence,
        // start with the system lang from the device
        super(systemLocale) {
    _getInitLocale();
  }

  final LocalPersistence _localePersistence;

  static final systemLocale = AppLocale(
      key: 'system',
      desc: 'systemLanuage',
      locale: Locale(
        Platform.localeName.substring(0, 2),
      ));

  // for the desc, dont forget to add the key-code of the language as desc in app_*.arb files
  // so far only de and en are added
  static final Map<String, AppLocale> locales = {
    'system': systemLocale,
    for (var locale in AppLocalizations.supportedLocales)
      locale.languageCode.substring(0, 2): AppLocale(
          key: locale.languageCode.substring(0, 2),
          desc: locale.languageCode.substring(0, 2),
          locale: locale)
  };

  Map<String, AppLocale> getLocales() => locales;

  _getInitLocale() async {
    final initLocale = await _localePersistence.getLocale();

    if (!_isValidLocale(initLocale)) {
      return;
    }

    if (initLocale == 'system') {
      emit(systemLocale);
    } else {
      final locale = Locale(initLocale);
      emit(
        AppLocale(
            key: locale.languageCode.substring(0, 2),
            desc: locale.languageCode.substring(0, 2),
            locale: locale),
      );
    }
  }

  changeLocale(AppLocale appLocale) {
    emit(appLocale);
    _localePersistence.saveLocale(appLocale.key);
  }

  bool _isValidLocale(String localeKey) {
    return (localeKey.isNotEmpty);
  }
}
