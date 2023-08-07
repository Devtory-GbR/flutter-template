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

List<RouteBase> appRoutes(GlobalKey<NavigatorState> rootNavigatorKey,
    GlobalKey<NavigatorState> homeNavigatorKey) {
  return [
    GoRoute(path: '/', redirect: (_, __) => '/dashboard'),
    ShellRoute(
      navigatorKey: homeNavigatorKey,
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return HomeMenu(child: child);
      },
      routes: [
        GoRoute(
            parentNavigatorKey: homeNavigatorKey,
            path: '/dashboard',
            builder: (context, state) => const DashboardPage()),
        GoRoute(
          parentNavigatorKey: homeNavigatorKey,
          path: '/settings',
          builder: (context, state) => const SettingsPage(),
          routes: [
            GoRoute(
                parentNavigatorKey: rootNavigatorKey,
                path: 'themes',
                builder: (context, state) => const ThemePage()),
            GoRoute(
                parentNavigatorKey: rootNavigatorKey,
                path: 'locales',
                builder: (context, state) => const LocalePage()),
            GoRoute(
                parentNavigatorKey: rootNavigatorKey,
                path: 'help',
                builder: (context, state) => const AboutPage(),
                routes: [
                  GoRoute(
                      parentNavigatorKey: rootNavigatorKey,
                      path: 'device_info',
                      builder: (context, state) => const DeviceInfoPage()),
                  GoRoute(
                    parentNavigatorKey: rootNavigatorKey,
                    path: 'logs',
                    builder: (context, state) => const LogPage(),
                    routes: [
                      GoRoute(
                        parentNavigatorKey: rootNavigatorKey,
                        path: ':logId',
                        builder: (context, state) {
                          final logId = state.pathParameters['logId'];
                          return LogDetailPage(
                            logId: logId != null ? int.parse(logId) : null,
                          );
                        },
                      ),
                    ],
                  ),
                ]),
          ],
        )
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
