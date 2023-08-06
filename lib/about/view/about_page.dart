import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/about/about.dart';
import 'package:myapp/widgets/widgets.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PackageInfoCubit>(
      create: (context) => PackageInfoCubit(),
      child: BlocBuilder<PackageInfoCubit, PackageInfo>(
        builder: (context, packageInfo) {
          return Scaffold(
            appBar: AppBar(
              title: Column(
                children: [
                  Text(AppLocalizations.of(context)!.title),
                ],
              ),
              bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(24),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      AppLocalizations.of(context)!
                          .version(packageInfo.version),
                    ),
                  )),
            ),
                  ),
                )),
          ),
          body: Column(children: [
            Expanded(flex: 1, child: Container()),
            Container(
              padding: const EdgeInsets.only(top: 32.0),
              alignment: Alignment.center,
              child: Image.asset('assets/images/logo.png'),
            ),
            Expanded(flex: 2, child: Container()),
            SimpleList(
              isFullPage: false,
              sections: [
                SimpleListSection(
                  marginBottom: false,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.document_scanner),
                      title: Text(AppLocalizations.of(context)!.license),
                      onTap: () async {
                        showLicensePage(context: context);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.description),
                      title: Text(AppLocalizations.of(context)!.log),
                      onTap: () => context.push('/about/logs'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.device_unknown),
                      title: Text(AppLocalizations.of(context)!.deviceInfo),
                      onTap: () => context.push('/about/device_info'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.help),
                      title: Text(AppLocalizations.of(context)!.help),
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.only(left: 12.0),
              child: Text(
                AppLocalizations.of(context)!.version(
                    '${packageInfo.version}+${packageInfo.buildNumber}'),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.only(left: 12.0, bottom: 6.0),
              child: Text(
                'Copyright (c) 2023, Devtory.io All right reserved',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ]),
          );
        },
      ),
    );
  }
}
