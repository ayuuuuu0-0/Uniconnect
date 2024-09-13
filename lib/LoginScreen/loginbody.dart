import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:uniconnect/DialogBox/error_dialog.dart';
import 'package:uniconnect/DialogBox/loading_dialog.dart';
import 'package:uniconnect/ForgotPassword/forgot_password.dart';
import 'package:uniconnect/HomeScreen/HomeScreen.dart';
import 'package:uniconnect/LoginScreen/loginbackground.dart';
import 'package:uniconnect/LoginScreen/rounded_password_field.dart';
import 'package:uniconnect/SignUpScreen/signin_page.dart';
import 'package:uniconnect/Widgets/Already_Registered.dart';
import 'package:uniconnect/Widgets/Button.dart';
import 'package:uniconnect/Widgets/rounded_button.dart';
import 'package:uniconnect/Widgets/rounded_input_field.dart';

class LoginBody extends StatefulWidget {
  const LoginBody({Key? key}) : super(key: key);

  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _login() async {
    showDialog(
        context: context,
        builder: (_) {
          return LoadingAlertDialog(
            message: 'Please wait',
          );
        });

    User? currentUser;
    await _auth
        .signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    )
        .then((auth) {
      currentUser = auth.user;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) {
            return ErrorAlertDialog(Message: error.message.toString());
          });
    });
    if (currentUser != null) {
      //ignore: use_build_context_synchronously
      Navigator.pop(context);
      //ignore: use_build_Context_synchronously
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      print('error');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return LoginBackground(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: size.height * 0.04,
            ),
            Lottie.asset(
              'assets/animation/login2.json',
              height: size.height * 0.32,
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            RoundedInputField(
              hintText: 'Email',
              icon: Icons.person,
              onChanged: (value) {
                _emailController.text = value;
              },
            ),
            const SizedBox(
              height: 6,
            ),
            RoundedPasswordField(
              onChanged: (value) {
                _passwordController.text = value;
              },
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ForgotPassword()));
                },
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 19,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
            NeoPopButtonComponent(
              color: Colors.white,
              text: 'LOGIN',
              onTapDown: () => HapticFeedback.vibrate(),
              onTapUp: () {
                _emailController.text.isNotEmpty &&
                        _passwordController.text.isNotEmpty
                    ? _login()
                    : showDialog(
                        context: context,
                        builder: (context) {
                          return ErrorAlertDialog(
                              Message:
                                  'Please write email & password for Login');
                        });
              },
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            AlreadyHaveAnAccount(
              login: true,
              press: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignUpScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
