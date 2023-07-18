import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:myapp/login/bloc/bloc/login_bloc.dart';
import 'package:myapp/login/view/login_form.dart';
import 'package:repositories/repositories.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      create: (context) => LoginBloc(
        authenticationRepository: context.read<AuthenticationRepository>(),
      ),
      child: Builder(builder: (context) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: Image.asset('assets/images/logo.png'),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 12)),
                      Text(
                        AppLocalizations.of(context)!.title,
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const Padding(padding: EdgeInsets.only(top: 12)),
                      Text(
                        '${AppLocalizations.of(context)!.code}: max',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const Padding(padding: EdgeInsets.only(top: 64)),
                    ],
                  ),
                ),
                const LoginForm(),
              ],
            ),
          ),
        );
      }),
    );
  }
}
