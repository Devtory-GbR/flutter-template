part of 'login_bloc.dart';

class LoginState extends Equatable {
  const LoginState({
    this.status = FormzSubmissionStatus.initial,
    this.code = const Code.pure(),
    this.isValid = false,
  });

  final FormzSubmissionStatus status;
  final Code code;
  final bool isValid;

  LoginState copyWith({
    FormzSubmissionStatus? status,
    Code? code,
    bool? isValid,
  }) {
    return LoginState(
      status: status ?? this.status,
      code: code ?? this.code,
      isValid: isValid ?? this.isValid,
    );
  }

  @override
  List<Object> get props => [status, code];

  @override
  String toString() => '$code, status: $status';
}
