import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/about/about.dart';
import 'package:myapp/authentication/authentication.dart';
import 'package:myapp/home/home.dart';
import 'package:myapp/init/init.dart';
import 'package:myapp/log/log.dart';
import 'package:myapp/login/login.dart';
import 'package:myapp/settings/settings.dart';

final Map<Pattern, dynamic Function(BuildContext, BeamState, Object?)>
    appRoutes = {
  '/': (context, state, data) {
    final tab = state.queryParameters['tab'];
    int index = 0;
    switch (tab) {
      case 'dashboard':
        index = 0;
        break;
      case 'settings':
        index = 1;
        break;
    }

    return HomePage(initialIndex: index);
  },
  '/init': (context, state, data) => const SplashPage(),
  '/login': (context, state, data) => const LoginPage(),
  '/themes': (context, state, data) => const ThemePage(),
  '/locales': (context, state, data) => const LocalePage(),
  '/about': (context, state, data) => AboutPage(),
  '/about/device_info': (context, state, data) => DeviceInfoPage(),
  '/about/logs': (context, state, data) => const LogPage()
};

final List<BeamGuard> appGuards = [
  BeamGuard(
      pathPatterns: ['/init'],
      guardNonMatching: true,
      check: ((context, location) => context.read<InitializedCubit>().state),
      beamToNamed: (origin, target) => '/init'),
  BeamGuard(
      pathPatterns: ['/init'],
      check: ((context, location) => !context.read<InitializedCubit>().state),
      beamToNamed: (origin, target) => '/'),
  BeamGuard(
      pathPatterns: ['/login', '/init'],
      guardNonMatching: true,
      check: ((context, location) =>
          context.read<AuthenticationBloc>().isAuthenticated()),
      beamToNamed: (origin, target) => '/login'),
  BeamGuard(
      pathPatterns: ['/login'],
      check: ((context, location) =>
          !context.read<AuthenticationBloc>().isAuthenticated()),
      beamToNamed: (origin, target) => '/'),
];
