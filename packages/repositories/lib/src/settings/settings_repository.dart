import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

abstract class ThemePersistence {
  Future<String> getThemeKey();
  Future<void> saveTheme(String themeKey);
}

abstract class LocalPersistence {
  Future<String> getLocale();
  Future<void> saveLocale(String locale);
}

class SettingsRepository implements ThemePersistence, LocalPersistence {
  SettingsRepository();

  static const _kThemePersistenceKey = '__theme_persistence_key__';
  static const _kLocalePersistenceKey = '__theme_locale_key__';

  @override
  Future<String> getThemeKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kThemePersistenceKey) ?? '';
  }

  @override
  Future<void> saveTheme(String themeKey) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kThemePersistenceKey, themeKey);
  }

  @override
  Future<String> getLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kLocalePersistenceKey) ?? '';
  }

  @override
  Future<void> saveLocale(String locale) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_kLocalePersistenceKey, locale);
  }
}
