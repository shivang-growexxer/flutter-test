import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:task_manager/config/enums.dart';
import 'package:task_manager/config/sessions/session_controller.dart';
import 'package:task_manager/repository/auth/login_repository.dart';

part 'login_event.dart';
part 'login_states.dart';

class LoginBloc extends Bloc<LoginEvents, LoginStates> {
  final LoginRepository loginRepository;
  LoginBloc({required this.loginRepository}) : super(const LoginStates()) {
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<LoginApi>(_loginApi);
  }

  void _onEmailChanged(EmailChanged event, Emitter<LoginStates> emit) {
    emit(state.copyWith(email: event.email));
  }

  void _onPasswordChanged(PasswordChanged event, Emitter<LoginStates> emit) {
    emit(state.copyWith(password: event.password));
  }

  void _loginApi(LoginApi event, Emitter<LoginStates> emit) async {
    Map data = {'email': event.email, 'password': event.password};
    emit(state.copyWith(postApiStatus: PostApiStatus.loading));
    await loginRepository
        .loginApi(data)
        .then((value) async {
          if (value.error.isNotEmpty) {
            emit(
              state.copyWith(
                message: value.error.toString(),
                postApiStatus: PostApiStatus.error,
              ),
            );
          } else {
            await SessionController().saveUserInPreference(value);
            await SessionController().getUserFromPreference();
            emit(
              state.copyWith(
                message: 'Login successfull',
                postApiStatus: PostApiStatus.success,
              ),
            );
          }
        })
        .catchError((error) {
          emit(
            state.copyWith(
              message: error.toString(),
              postApiStatus: PostApiStatus.error,
            ),
          );
        });
  }
}
