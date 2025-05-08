import 'package:flutter/material.dart';
import 'package:flutter_notes/utils/routes/routes_name.dart';

class SplashServices {
  void navigateToHome(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 3));
    Navigator.pushReplacementNamed(context, RoutesName.home);
  }
} 