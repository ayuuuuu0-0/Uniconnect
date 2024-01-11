import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uniconnect/HomeScreen/HomeScreen.dart';
import 'package:uniconnect/WelcomeScreen/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  startTimer() {
    Timer(const Duration(seconds: 6), () async {
      if (FirebaseAuth.instance.currentUser != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      }
      else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                Image.asset("assets/images/11668571_20943645.jpg",),
              const SizedBox(height: 10.0,),
              const Padding(
                padding: EdgeInsets.all(18.0),
                child: Center(
                  child: Text(" Sell, Purchase or Rent College Essentials ",
                    style: TextStyle(
                      fontSize: 17.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Varela",
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }
}
