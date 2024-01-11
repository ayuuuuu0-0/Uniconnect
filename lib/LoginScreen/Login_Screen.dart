import 'package:flutter/material.dart';
import 'package:uniconnect/LoginScreen/loginbody.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: LoginBody(),
    );
  }
}
