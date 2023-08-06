import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:myapp/about/about.dart';
import 'package:myapp/widgets/widgets.dart';

class DeviceInfoPage extends StatelessWidget {
  const DeviceInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DeviceInfoCubit>(
      create: (context) => DeviceInfoCubit(),
      child: BlocBuilder<DeviceInfoCubit, Map<String, dynamic>>(
          builder: (context, deviceInfo) {
        return Scaffold(
          appBar: AppBar(
            title: Column(
              children: [
                Text(AppLocalizations.of(context)!.deviceInfo),
              ],
            ),
          ),
          body: SimpleList(
            sections: [
              SimpleListSection(
                children: [
                  for (var property in deviceInfo.keys.toList()..sort())
                    Row(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            property,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                            child: Container(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 12.0),
                          child: Text(
                            '${deviceInfo[property]}',
                            maxLines: 10,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )),
                      ],
                    )
                ],
              )
            ],
          ),
        );
      }),
    );
  }
}
