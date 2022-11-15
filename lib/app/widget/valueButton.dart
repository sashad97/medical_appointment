import 'package:flutter/material.dart';
import 'package:health/utils/constants/screensize.dart';

class ValueButton extends StatelessWidget {
  final int quantity;
  final Function onPressed;

  ValueButton({required this.quantity, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Container(
        height: Responsive.height(0.12, context),
        width: Responsive.width(0.23, context),
        alignment: Alignment.center,
        child: Text(
          quantity.toString(),
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          textAlign: TextAlign.center,
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            // border: Border.all(width: 1.0, color: Colors.orangeAccent),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)]),
      ),
      onPressed: onPressed(context),
    );
  }
}
