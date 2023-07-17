part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginCodeChanged extends LoginEvent {
  const LoginCodeChanged(this.code);

  final String code;

  @override
  List<Object> get props => [code];
}

class LoginSubmitted extends LoginEvent {
  const LoginSubmitted();
}
