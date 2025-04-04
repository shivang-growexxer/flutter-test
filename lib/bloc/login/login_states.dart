part of 'login_bloc.dart';

class LoginStates extends Equatable {
  const LoginStates({
    this.email = '',
    this.password = '',
    this.message = '',
    this.postApiStatus = PostApiStatus.initial,
  });

  final String email;
  final String password;
  final String message;
  final PostApiStatus postApiStatus;

  LoginStates copyWith({
    String? email,
    String? password,
    PostApiStatus? postApiStatus,
    String? message,
  }) {
    return LoginStates(
      email: email ?? this.email,
      password: password ?? this.password,
      postApiStatus: postApiStatus ?? this.postApiStatus,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [email, password, postApiStatus, message];
}
