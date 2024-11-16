import 'package:flutter/material.dart';
import 'package:uniconnect/WelcomeScreen/welcome_screen.dart';

class ErrorAlertDialog extends StatelessWidget {

  final String Message;
  const ErrorAlertDialog({required this.Message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Text(Message, style: TextStyle(color: Colors.black),),
      actions: [
        ElevatedButton(onPressed: (){
          Navigator.pushReplacement
            (context, MaterialPageRoute(
              builder: (context) => WelcomeScreen()));
        }, child: const
        Center(child: Text('OK'),))
      ],
    );
  }
}
