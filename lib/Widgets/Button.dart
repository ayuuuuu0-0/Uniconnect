import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "package:neopop/neopop.dart";

class NeoPopButtonComponent extends StatelessWidget {
  final Color color;
  final VoidCallback onTapUp;
  final VoidCallback onTapDown;
  final String text;
  final EdgeInsets padding;

  const NeoPopButtonComponent({
    Key? key,
    required this.color,
    required this.onTapUp,
    required this.onTapDown,
    required this.text,
    this.padding = const EdgeInsets.symmetric(horizontal: 90, vertical: 15),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NeoPopButton(
      onTapUp: onTapUp,
      onTapDown: onTapDown,
      color: color,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 90, vertical: 15),
        child:
        Text(
          text,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            fontFamily: "Poppins",
          ),
        ),
      ),
    );
  }
}