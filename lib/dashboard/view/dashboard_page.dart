import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:myapp/authentication/authentication.dart';
import 'package:myapp/dashboard/cubit/dashboard_cubit.dart';
import 'package:repositories/repositories.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.dashboard),
      ),
      body: BlocProvider<DashboardCubit>(
        create: (context) => DashboardCubit(testRepository: TestRepository()),
        child: Builder(builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListView(
              children: [
                BlocBuilder<AuthenticationBloc, AuthenticationState>(
                  builder: (context, state) {
                    return Text(
                      AppLocalizations.of(context)!.hello(state.user.name),
                      style: Theme.of(context).textTheme.headlineSmall,
                    );
                  },
                ),
                const Padding(padding: EdgeInsets.only(top: 24.0)),
                FilledButton(
                    onPressed: () =>
                        context.read<DashboardCubit>().simulateHardError(),
                    child:
                        Text(AppLocalizations.of(context)!.simulateHardError)),
                const Padding(padding: EdgeInsets.only(top: 12.0)),
                FilledButton(
                    onPressed: () =>
                        context.read<DashboardCubit>().simulateClientError(),
                    child: Text(
                        AppLocalizations.of(context)!.simulateClientError)),
                const Padding(padding: EdgeInsets.only(top: 12.0)),
                FilledButton(
                    onPressed: () =>
                        context.read<DashboardCubit>().simulateHttpError(),
                    child:
                        Text(AppLocalizations.of(context)!.simulateHttpError)),
                const Padding(padding: EdgeInsets.only(top: 12.0)),
                FilledButton(
                    onPressed: () =>
                        context.read<DashboardCubit>().simulateError401(),
                    child: Text(AppLocalizations.of(context)!
                        .simulateTokenInvalidError)),
              ],
            ),
          );
        }),
      ),
    );
  }
}
