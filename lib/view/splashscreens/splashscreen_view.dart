import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:health/utils/constants/colors.dart';
import 'package:health/view/authViews/login/loginpage.dart';
import 'package:health/view/homepage/homepage.dart';
import 'package:health/view/splashscreens/splashscreen_view_model.dart';
import 'package:provider_architecture/_viewmodel_provider.dart';

class SplashscreenView extends StatelessWidget {
  //const SplashscreenView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<SplashscreenViewModel>.withConsumer(
        viewModelBuilder: () => SplashscreenViewModel(),
        builder: (context, model, child) {
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
                        'HEALTH',
                        style: TextStyle(
                            color: AppColors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 5),
                      ),
                    ],
                  ),
                  splashIconSize: 200,
                  splashTransition: SplashTransition.scaleTransition,
                  nextScreen: FutureBuilder<dynamic>(
                    future: model.isuserloggedin(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return LogInPage();
                      } else {
                        return Homepage();
                      }
                    },
                  )),
            ),
          );
        });
  }
}
