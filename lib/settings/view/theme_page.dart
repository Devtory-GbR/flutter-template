import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:myapp/settings/settings.dart';
import 'package:myapp/widgets/widgets.dart';

class ThemePage extends StatelessWidget {
  const ThemePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.theme),
      ),
      body: const _ThemeList(),
    );
  }
}

class _ThemeList extends StatelessWidget {
  const _ThemeList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, AppTheme>(
      builder: (context, apptheme) {
        return SimpleList(
          sections: [
            SimpleListSection(children: [
              for (var item in context.read<ThemeCubit>().getThemes().values)
                ListTile(
                  title: Text(
                      AppLocalizations.of(context)!.themeChoice(item.desc)),
                  selected: item.key == apptheme.key,
                  onTap: () => context.read<ThemeCubit>().changeTheme(item),
                ),
            ]),
          ],
        );
      },
    );
  }
}
