part of 'login_bloc.dart';

abstract class LoginEvents extends Equatable {
  const LoginEvents();

  @override
  List<Object> get props => [];
}

class EmailChanged extends LoginEvents {
  const EmailChanged({required this.email});
  final String email;

  @override
  List<Object> get props => [email];
}

class PasswordChanged extends LoginEvents {
  const PasswordChanged({required this.password});
  final String password;

  @override
  List<Object> get props => [password];
}

class EmailUnfocussed extends LoginEvents {}

class PasswordUnfocussed extends LoginEvents {}

class LoginApi extends LoginEvents {
  final String email;
  final String password;
  const LoginApi({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}
