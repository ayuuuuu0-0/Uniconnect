import 'package:flutter/material.dart';
import 'package:uniconnect/SignUpScreen/signin_page.dart';
import 'package:uniconnect/WelcomeScreen/background.dart';
import 'package:uniconnect/Widgets/rounded_button.dart';
import '../LoginScreen/Login_Screen.dart';

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
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: "Poppins"),
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            Image.asset(
              'assets/images/newSplash2.png',
              height: size.height * 0.40,
            ),
            RoundedButton(
                text: 'LOGIN',
                press: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                }),
            RoundedButton(
              text: 'SIGN UP',
              press: () {
                Navigator.pushReplacement(
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
