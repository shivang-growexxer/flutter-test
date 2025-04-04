import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_manager/bloc/login/login_bloc.dart';
import 'package:task_manager/config/enums.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({
    super.key,
    required GlobalKey<FormState> formKey,
    required this.emailController,
    required this.passwordController,
  }) : _formKey = formKey;

  final GlobalKey<FormState> _formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginStates>(
      buildWhen:
          (previous, current) =>
              current.postApiStatus != previous.postApiStatus,
      builder: (context, state) {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.deepPurpleAccent, // Text color
            padding: EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 30,
            ), // Padding
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30), // Rounded corners
            ),
            elevation: 5, // Button elevation
          ),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              context.read<LoginBloc>().add(
                LoginApi(
                  email: emailController.text,
                  password: passwordController.text,
                ),
              );
            }
          },
          child:
              state.postApiStatus == PostApiStatus.loading
                  ? SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 3, // Thicker loading indicator
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                  : Text(
                    'Login',
                    style: GoogleFonts.montserrat(
                      fontSize: 18, // Text size
                      fontWeight: FontWeight.bold, // Bold text
                    ),
                  ),
        );
      },
    );
  }
}
