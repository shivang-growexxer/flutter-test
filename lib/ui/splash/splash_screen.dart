import 'package:flutter/material.dart';
import 'package:task_manager/config/sessions/splash_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SplashServices _splashServices = SplashServices();

  @override
  void initState() {
    super.initState();
    _splashServices.isLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Text(
            'Task Manager',
            style: TextStyle(color: Colors.black, fontSize: 35),
          ),
        ),
      ),
    );
  }
}
