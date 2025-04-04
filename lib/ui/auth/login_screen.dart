// ignore_for_file: unused_field
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:task_manager/bloc/login/login_bloc.dart';
import 'package:task_manager/config/enums.dart';
import 'package:task_manager/config/routes/routes_name.dart';
import 'package:task_manager/main.dart';
import 'package:task_manager/ui/auth/widgets/input_field.dart';

import 'widgets/login_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late LoginBloc _loginBloc;
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FlutterSecureStorage storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _loginBloc = LoginBloc(loginRepository: getIt());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => LoginBloc(loginRepository: getIt()),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InputField(
                      isEmail: true,
                      controller: emailController,
                      emailFocusNode: emailFocusNode,
                      hintText: 'Email',
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Email is required';
                        }
                        if (!value.contains('@') || !value.contains('.')) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    InputField(
                      isEmail: false,
                      controller: passwordController,
                      emailFocusNode: passwordFocusNode,
                      hintText: 'Password',
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Password is required';
                        }
                        if (value.length < 8) {
                          return 'Password must be at least 8 characters long';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    BlocListener<LoginBloc, LoginStates>(
                      listenWhen:
                          (previous, current) =>
                              current.postApiStatus != previous.postApiStatus,
                      listener: (context, state) {
                        if (state.postApiStatus == PostApiStatus.error) {
                          // Handle error
                        }
                        if (state.postApiStatus == PostApiStatus.success) {
                          context.goNamed(RoutesName.taskScreen);
                        }
                      },
                      child: LoginButton(
                        formKey: _formKey,
                        emailController: emailController,
                        passwordController: passwordController,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
