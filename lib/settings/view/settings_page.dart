import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/authentication/authentication.dart';
import 'package:myapp/settings/settings.dart';
import 'package:myapp/widgets/widgets.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
      ),
      body: const _SettingsList(),
    );
  }
}

class _SettingsList extends StatefulWidget {
  const _SettingsList();

  @override
  State<_SettingsList> createState() => _SettingsListState();
}

class _SettingsListState extends State<_SettingsList> {
  @override
  Widget build(BuildContext context) {
    return SimpleList(
      sections: [
        SimpleListSection(
          children: [
            BlocBuilder<LocaleCubit, AppLocale>(builder: (context, appLocale) {
              return ListTile(
                  leading: const Icon(Icons.language),
                  title: Text(AppLocalizations.of(context)!.language),
                  subtitle: Text(AppLocalizations.of(context)!
                      .languageChoice(appLocale.desc)),
                  onTap: () => context.push('/locales'));
            }),
            BlocBuilder<ThemeCubit, AppTheme>(
              builder: (context, appTheme) {
                return ListTile(
                  leading: const Icon(Icons.brush),
                  title: Text(AppLocalizations.of(context)!.theme),
                  subtitle: Text(
                      AppLocalizations.of(context)!.themeChoice(appTheme.desc)),
                  onTap: () => context.push('/themes'),
                );
              },
            ),
          ],
        ),
        SimpleListSection(
          children: [
            ListTile(
              leading: const Icon(Icons.info),
              title: Text(AppLocalizations.of(context)!.about),
              onTap: () => context.push('/about'),
            ),
          ],
        ),
        SimpleListSection(
          children: [
            ListTile(
              title: Center(
                  child: Text(
                AppLocalizations.of(context)!.logout,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              )),
              onTap: () {
                context
                    .read<AuthenticationBloc>()
                    .add(AuthenticationLogoutRequested());
              },
            ),
          ],
        )
      ],
    );
  }
}
