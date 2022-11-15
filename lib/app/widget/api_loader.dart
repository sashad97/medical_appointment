import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:health/utils/constants/colors.dart';

class ApiLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      alignment: Alignment.center,
      children: [
        SpinKitChasingDots(
          color: AppColors.loadingColor200,
          size: 40,
        )
      ],
    );
  }
}
