import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repositories/repositories.dart';

class InitializedCubit extends Cubit<bool> {
  InitializedCubit() : super(false);

  initApp({
    required AuthenticationRepository authenticationRepository,
  }) async {
    // At these point you can do all the heavy stuff to init the app
    // a splashscreen is showing so you can also extends the state with a nice text
    // and show each step or whatever you prefer
    // for now we wanna just init the auth-repo to be sure if there is a token and if it is still valid
    // only after that we want to show the real app, so that the routing and guards working fine

    await authenticationRepository.init();

    // just some delay so that the screen is not changng so fast... :D
    await Future.delayed(const Duration(microseconds: 300));
    emit(true);
  }
}
