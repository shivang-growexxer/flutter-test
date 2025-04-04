import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/bloc/login/login_bloc.dart';

class InputField extends StatelessWidget {
  const InputField({
    super.key,
    required this.emailFocusNode,
    required this.hintText,
    required this.validator,
    required this.controller,
    required this.isEmail,
  });

  final FocusNode emailFocusNode;
  final String hintText;
  final FormFieldValidator<String> validator;
  final TextEditingController controller;
  final bool isEmail;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginStates>(
      buildWhen:
          isEmail
              ? (current, previous) => current.email != previous.email
              : (current, previous) => current.password != previous.password,
      builder: (context, state) {
        return TextFormField(
          controller: controller,
          keyboardType:
              isEmail ? TextInputType.emailAddress : TextInputType.text,
          focusNode: emailFocusNode,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(30)),
              borderSide: const BorderSide(
                color: Colors.deepPurpleAccent,
                width: 1,
              ),
            ),
            prefixIcon: Icon(
              isEmail
                  ? Icons.person
                  : Icons
                      .lock, // Show person icon for email and lock icon for password
            ),
          ),
          onChanged: (value) {
            if (isEmail) {
              context.read<LoginBloc>().add(
                EmailChanged(email: controller.text),
              );
            } else {
              context.read<LoginBloc>().add(
                PasswordChanged(password: controller.text),
              );
            }
          },
          validator: validator,
          onFieldSubmitted: (value) {},
        );
      },
    );
  }
}
