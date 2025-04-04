import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:task_manager/config/routes/routes_name.dart';
import 'package:task_manager/config/sessions/session_controller.dart';

class SplashServices {
  void isLogin(BuildContext context) {
    SessionController()
        .getUserFromPreference()
        .then((value) {
          if (SessionController().isLogin ?? false) {
            Timer(
              Duration(seconds: 3),
              () => context.goNamed(RoutesName.taskScreen),
            );
          } else {
            Timer(
              Duration(seconds: 3),
              () => context.goNamed(RoutesName.loginScreen),
            );
          }
        })
        .onError((error, StackTrace) {
          Timer(
            Duration(seconds: 3),
            () => context.goNamed(RoutesName.loginScreen),
          );
        });
  }
}
