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

final _parentKey = GlobalKey<NavigatorState>();
final _shellKey = GlobalKey<NavigatorState>();

List<RouteBase> appRoutes(GlobalKey<NavigatorState> rootNavigatorKey) {
  final homeNavigatorKey = GlobalKey<NavigatorState>();

  return [
    ShellRoute(
      navigatorKey: homeNavigatorKey,
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return HomeMenu(child: child);
      },
      routes: [
        GoRoute(
            parentNavigatorKey: homeNavigatorKey,
            path: '/',
            builder: (context, state) => const DashboardPage()),
        GoRoute(
            parentNavigatorKey: homeNavigatorKey,
            path: '/settings',
            builder: (context, state) => const SettingsPage())
      ],
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/init',
      builder: (context, state) => const SplashPage(),
      redirect: (context, state) =>
          context.read<InitializedCubit>().state ? '/' : null,
    ),
    GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/login',
        builder: (context, state) => const LoginPage(),
        redirect: (context, state) =>
            context.read<AuthenticationBloc>().state.status ==
                    AuthenticationStatus.authenticated
                ? '/'
                : null),
    GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/themes',
        builder: (context, state) => const ThemePage()),
    GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/locales',
        builder: (context, state) => const LocalePage()),
    GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/about',
        builder: (context, state) => AboutPage()),
    GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/about/device_info',
        builder: (context, state) => DeviceInfoPage()),
    GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/about/logs',
        builder: (context, state) => const LogPage()),
  ];
}

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
