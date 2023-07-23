import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:formz/formz.dart';
import 'package:myapp/login/bloc/login_bloc.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listenWhen: (previous, current) => !previous.status.isFailure,
      listener: (context, state) {
        if (state.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context)!.codeIncorrect),
              ),
            );
        }
      },
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 450),
        child: const Column(
          children: [
            _CodeInput(),
            Padding(padding: EdgeInsets.all(12)),
            _LoginButton(),
          ],
        ),
      ),
    );
  }
}

class _CodeInput extends StatelessWidget {
  const _CodeInput();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.code != current.code,
      builder: (context, state) {
        return TextField(
          onChanged: (code) =>
              context.read<LoginBloc>().add(LoginCodeChanged(code)),
          textInputAction: TextInputAction.done,
          onSubmitted: (_) =>
              context.read<LoginBloc>().add(const LoginSubmitted()),
          decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: AppLocalizations.of(context)!.code,
              errorText: state.code.displayError != null
                  ? AppLocalizations.of(context)!.codeRequired
                  : null),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return state.status.isInProgress
            ? const CircularProgressIndicator()
            : ConstrainedBox(
                constraints: const BoxConstraints(
                    minHeight: 40, minWidth: double.maxFinite),
                child: FilledButton(
                  onPressed: () =>
                      context.read<LoginBloc>().add(const LoginSubmitted()),
                  child: Text(AppLocalizations.of(context)!.login),
                ),
              );
      },
    );
  }
}
