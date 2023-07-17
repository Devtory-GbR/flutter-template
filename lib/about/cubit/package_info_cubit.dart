import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:package_info_plus/package_info_plus.dart';

class PackageInfoCubit extends Cubit<PackageInfo> {
  PackageInfoCubit()
      : super(
          PackageInfo(
              appName: '', packageName: '', version: '', buildNumber: ''),
        ) {
    PackageInfo.fromPlatform().then((value) => emit(value)).onError(
        (error, stackTrace) =>
            Logger("PackageInfo").shout(error, error, stackTrace));
  }
}
