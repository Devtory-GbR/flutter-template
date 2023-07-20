import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/about/about.dart';
import 'package:myapp/authentication/authentication.dart';
import 'package:myapp/dashboard/dashboard.dart';
import 'package:myapp/home/home.dart';
import 'package:myapp/init/init.dart';
import 'package:myapp/log/log.dart';
import 'package:myapp/login/login.dart';
import 'package:myapp/settings/settings.dart';
import 'package:repositories/repositories.dart';

final List<RouteBase> appRoutes = [
  ShellRoute(
    builder: (BuildContext context, GoRouterState state, Widget child) {
      return HomeMenu(child: child);
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const DashboardPage()),
      GoRoute(
          path: '/settings', builder: (context, state) => const SettingsPage())
    ],
  ),
  GoRoute(
    path: '/init',
    builder: (context, state) => const SplashPage(),
    redirect: (context, state) =>
        context.read<InitializedCubit>().state ? '/' : null,
  ),
  GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
      redirect: (context, state) =>
          context.read<AuthenticationBloc>().state.status ==
                  AuthenticationStatus.authenticated
              ? '/'
              : null),
  GoRoute(path: '/themes', builder: (context, state) => const ThemePage()),
  GoRoute(path: '/locales', builder: (context, state) => const LocalePage()),
  GoRoute(path: '/about', builder: (context, state) => AboutPage()),
  GoRoute(
      path: '/about/device_info',
      builder: (context, state) => DeviceInfoPage()),
  GoRoute(path: '/about/logs', builder: (context, state) => const LogPage()),
];

String? appRedirect(BuildContext context, GoRouterState state) {
  if (!context.read<InitializedCubit>().state) {
    return '/init';
  }
  if (context.read<AuthenticationBloc>().state.status !=
      AuthenticationStatus.authenticated) {
    return '/login';
  }
  return null;
}
