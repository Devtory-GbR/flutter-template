import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:myapp/authentication/authentication.dart';
import 'package:myapp/dashboard/dashboard.dart';
import 'package:myapp/home/cubit/home_cubit.dart';
import 'package:myapp/settings/settings.dart';
import 'package:repositories/repositories.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.initialIndex});

  final int initialIndex;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(initialIndex: initialIndex),
      child: BlocBuilder<HomeCubit, int>(
        builder: (context, selectedIndex) {
          return BlocListener<AuthenticationBloc, AuthenticationState>(
            listenWhen: (previous, current) =>
                previous.status == AuthenticationStatus.authenticated &&
                current.status == AuthenticationStatus.unauthenticated,
            listener: (context, state) {
              // set state to 0, so that after login we see the dashboard...
              // we maybe need to imporve it later so that the navigation with real urls also work..
              context.read<HomeCubit>().changeScreen(0);
            },
            child: Scaffold(
              body: IndexedStack(
                index: selectedIndex,
                children: const [DashboardPage(), SettingsPage()],
              ),
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: selectedIndex,
                onTap: (index) {
                  String location = '/?tab=dashboard';
                  switch (index) {
                    case 0:
                      location = '/?tab=dashboard';
                      break;
                    case 1:
                      location = '/?tab=settings';
                      break;
                  }
                  Beamer.of(context).update(
                    configuration: RouteInformation(
                      location: location,
                    ),
                    rebuild: false,
                  );
                  context.read<HomeCubit>().changeScreen(index);
                },
                items: [
                  BottomNavigationBarItem(
                      label: AppLocalizations.of(context)!.dashboard,
                      icon: const Icon(Icons.dashboard)),
                  BottomNavigationBarItem(
                      label: AppLocalizations.of(context)!.settings,
                      icon: const Icon(Icons.settings)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
