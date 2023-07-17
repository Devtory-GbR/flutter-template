import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:myapp/settings/settings.dart';
import 'package:myapp/widgets/widgets.dart';

class LocalePage extends StatelessWidget {
  const LocalePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.language),
      ),
      body: const _LocaleList(),
    );
  }
}

class _LocaleList extends StatelessWidget {
  const _LocaleList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, AppLocale>(
      builder: (context, appLocale) {
        return SimpleList(
          sections: [
            SimpleListSection(children: [
              for (var item in context.read<LocaleCubit>().getLocales().values)
                ListTile(
                  title: Text(
                      AppLocalizations.of(context)!.languageChoice(item.desc)),
                  selected: item.key == appLocale.key,
                  onTap: () => context.read<LocaleCubit>().changeLocale(item),
                )
            ]),
          ],
        );
      },
    );
  }
}
