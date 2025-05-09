import 'package:flutter/material.dart';
import 'package:flutter_notes/view_model/services/splash_services.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  SplashServices splashServices = SplashServices();

  @override
  void initState() {
    super.initState();
    splashServices.navigateToHome(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Amerika Foods',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontFamily: 'FuturaStd',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
