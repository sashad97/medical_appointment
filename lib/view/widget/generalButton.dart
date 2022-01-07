import 'package:flutter/material.dart';
import 'package:health/utils/constants/colors.dart';
import 'package:health/utils/constants/screensize.dart';

class CustomButton extends StatelessWidget {
  final Widget child;
  final Function onPressed;
  final BorderRadius borderRadius;
  final Color borderColor;
  final Color splashColor;
  // final String buttonText;
  final Color buttonTextColor;
  CustomButton(
      {Key key,
      @required this.child,
      this.onPressed,
      this.borderRadius = const BorderRadius.all(Radius.circular(10)),
      this.splashColor = AppColors.primaryColor,
      this.buttonTextColor = const Color(0xffFFFFFF),
      this.borderColor = Colors.transparent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        //padding: EdgeInsets.all(20),
        height: Responsive.height(0.06, context),
        width: Responsive.width(0.7, context),
        margin: EdgeInsets.symmetric(
          horizontal: Responsive.width(0.09, context),
        ),
        child: TextButton(
          style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: borderRadius,
                side: BorderSide(color: borderColor),
              ),
              primary: splashColor,
              backgroundColor: splashColor),

          onPressed: () {
            if (onPressed != null) {
              onPressed();
            }
          },
          child: child,
          //  child: Text(buttonText, style: TextStyle(fontSize:Responsive.width(0.00, context)
          //   ,color: buttonTextColor, fontFamily: 'Caros', fontWeight: FontWeight.w400),),
        ));
  }
}
