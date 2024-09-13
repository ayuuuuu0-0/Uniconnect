import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:uniconnect/SignUpScreen/signin_page.dart';
import 'package:uniconnect/WelcomeScreen/background.dart';
import 'package:uniconnect/Widgets/Button.dart';
import 'package:uniconnect/Widgets/rounded_button.dart';
import '../LoginScreen/Login_Screen.dart';
import "package:flutter/services.dart";

class WelcomeBody extends StatelessWidget {
  const WelcomeBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WelcomeBackground(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'College Cart',
              style: TextStyle(
                  fontSize: 60.0,
                  //fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: "DMSerifText"),
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            Lottie.asset(
              'assets/animation/welcome.json',
              height: size.height * 0.40,
            ),
            SizedBox(height: size.height * 0.1,),
            NeoPopButtonComponent(
                text: 'LOGIN',
                color: Colors.white,
                onTapUp: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginScreen()));
                },
              onTapDown: () => HapticFeedback.vibrate(),),
            SizedBox(height: 10),
            NeoPopButtonComponent(
              text: 'SIGN UP',
              color: Colors.white,
              onTapDown: () => HapticFeedback.vibrate(),
              onTapUp: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignUpScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
