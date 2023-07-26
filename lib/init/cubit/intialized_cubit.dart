import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:repositories/repositories.dart';

class InitializedCubit extends Cubit<bool> {
  final log = Logger('InitializedCubit');

  InitializedCubit() : super(false);

  void initApp({
    required AuthenticationRepository authenticationRepository,
  }) async {
    // At these point you can do all the heavy stuff to init the app
    // a splashscreen is showing so you can also extends the state with a nice text
    // and show each step or whatever you prefer
    // for now we wanna just init the auth-repo to be sure if there is a token and if it is still valid
    // only after that we want to show the real app, so that the routing and guards working fine
    try {
      await authenticationRepository.init();
    } catch (e, stackTrace) {
      // At these point we want to catch the error
      // so that on starting screen not already some weird messages plop up
      log.severe('InitError --  $e', e, stackTrace);
    }

    // just some delay so that the screen is not changng so fast... :D
    await Future.delayed(const Duration(microseconds: 300));
    emit(true);
  }
}
