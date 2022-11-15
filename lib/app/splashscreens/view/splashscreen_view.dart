import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health/utils/constants/colors.dart';
import 'package:health/utils/locator.dart';
import 'package:health/utils/mixins/ui_tool_mixin.dart';
import 'package:health/app/authViews/login/view/loginpage.dart';
import 'package:health/app/homepage/homepage.dart';
import '../cubit/splash_cubit.dart';
import '../state/splash_screen_state.dart';

class SplashscreenView extends StatelessWidget with UIToolMixin {
  SplashscreenView({Key? key}) : super(key: key);

  final AuthCubit _authCubit = locator<AuthCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      bloc: _authCubit,
      builder: (context, state) {
        return SingleChildScrollView(
          child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: AnimatedSplashScreen(
                  centered: true,
                  backgroundColor: AppColors.primaryColor,
                  splash: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('asset/images/health.png'),
                                fit: BoxFit.fill)),
                      ),
                      Text(
                        'HEALTHCARE VQMA',
                        style: TextStyle(
                            color: AppColors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 3),
                      ),
                    ],
                  ),
                  splashIconSize: 200,
                  splashTransition: SplashTransition.scaleTransition,
                  nextScreen:
                      state is AuthAuthenticated ? Homepage() : LogInPage())),
        );
      },
    );
  }
}
