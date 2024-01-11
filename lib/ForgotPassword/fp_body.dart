import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uniconnect/DialogBox/error_dialog.dart';
import 'package:uniconnect/ForgotPassword/Fp_background.dart';
import '../LoginScreen/Login_Screen.dart';

class ForgetBody extends StatefulWidget {

  @override
  State<ForgetBody> createState() => _ForgetBodyState();
}

class _ForgetBodyState extends State<ForgetBody> {

  final TextEditingController _forgetPassTextController =
  TextEditingController(text: '');

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _forgotPassSubmitForm() async {
    try
    {
      await _auth.sendPasswordResetEmail(
        email: _forgetPassTextController.text,
      );
      // ignore use_build_context_synchronously
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
    catch(error)
    {
     ErrorAlertDialog(Message: error.toString(),);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return ForgetBackground(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
            child: ListView(
              children: [
                SizedBox(height: size.height * 0.1,),
                const Text(
                  'Forget Password',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 55,
                    fontFamily: 'Bebas',
                  ),
                ),
                const SizedBox(height: 20,),
                const Text(
                  'Email Address',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 20,),
                TextField(
                  controller: _forgetPassTextController,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.black54,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 60,),
                MaterialButton(
                    onPressed: (){
                      _forgotPassSubmitForm();
                    },
                  color: Colors.black54,
                  elevation: 20,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Text(
                      'Reset Now',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
