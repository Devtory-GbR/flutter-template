import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:myapp/login/models/code.dart';
import 'package:repositories/repositories.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const LoginState()) {
    on<LoginCodeChanged>(_onCodeChanged);
    on<LoginSubmitted>(_onSubmitted);
  }

  final AuthenticationRepository _authenticationRepository;

  void _onCodeChanged(
    LoginCodeChanged event,
    Emitter<LoginState> emit,
  ) {
    final code = Code.dirty(event.code);
    emit(
      state.copyWith(
        code: code,
        isValid: Formz.validate([code]),
      ),
    );
  }

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    if (state.status.isInProgress) {
      return;
    }
    if (state.isValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      try {
        await _authenticationRepository.logIn(
          username: state.code.value,
          password: '',
        );
        emit(state.copyWith(status: FormzSubmissionStatus.success));
      } on UserPasswordIncorrectException catch (_) {
        emit(state.copyWith(status: FormzSubmissionStatus.failure));
      } catch (_) {
        emit(state.copyWith(status: FormzSubmissionStatus.failure));
        rethrow;
      }
    }
  }
}
