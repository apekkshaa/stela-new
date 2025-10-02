import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:stela_app/constants/colors.dart';
import 'package:stela_app/screens/home.dart';
import 'package:page_transition/page_transition.dart'; // Optional, for transition effect

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      duration: 3000,
      splash: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/STELA.png',
            height: 100,
          ),
          const SizedBox(height: 20),
          const Text(
            'STELA 5.0',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
      splashIconSize: 250,
      backgroundColor: primaryWhite, // or Colors.black if using white text/logo
      nextScreen: Home(),
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.fade,
    );
  }
}
