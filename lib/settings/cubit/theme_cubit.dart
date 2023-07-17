import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/settings/settings.dart';
import 'package:myapp/styles/themes.dart';
import 'package:repositories/repositories.dart';

class ThemeCubit extends Cubit<AppTheme> {
  ThemeCubit({required ThemePersistence themePersistence})
      : _themePersistence = themePersistence,
        super(themes.values.first) {
    _getInitTheme();
  }

  final ThemePersistence _themePersistence;

  // feel free to just ad more themes if you like
  // for the desc, dont forget to add the desc in app_en.arb
  static final Map<String, AppTheme> themes = {
    'primary':
        AppTheme(key: 'primary', desc: 'light', theme: AppThemes.primary),
    'primaryDark': AppTheme(
        key: 'primaryDark', desc: 'dark', theme: AppThemes.primaryDarkTheme)
  };

  Map<String, AppTheme> getThemes() => themes;

  _getInitTheme() async {
    final initThemeKey = await _themePersistence.getThemeKey();
    if (_isValidTheme(initThemeKey)) {
      emit(themes[initThemeKey]!);
    }
  }

  changeTheme(AppTheme appTheme) {
    emit(appTheme);
    _themePersistence.saveTheme(appTheme.key);
  }

  bool _isValidTheme(String themeKey) {
    return (themeKey.isNotEmpty && themes.keys.contains(themeKey));
  }
}
