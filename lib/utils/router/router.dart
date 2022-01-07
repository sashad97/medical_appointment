import 'package:flutter/material.dart';
import 'package:health/utils/router/routeNames.dart';
import 'package:health/view/authViews/SignUp/signup.dart';
import 'package:health/view/authViews/login/loginpage.dart';
import 'package:health/view/authViews/resetpassword/resetpassword.dart';
import 'package:health/view/booking_form/booking_form.dart';
import 'package:health/view/booking_history/booking_history.dart';
import 'package:health/view/bookings/bookings.dart';
import 'package:health/view/homepage/homepage.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case SignInPageRoute:
      return _getPageRoute(
        routeName: settings.name ?? "",
        viewToShow: LogInPage(),
      );

    case SignUpPageRoute:
      return _getPageRoute(
        routeName: settings.name ?? "",
        viewToShow: SignUpView(),
      );

    case HomePageRoute:
      return _getPageRoute(
        routeName: settings.name ?? "",
        viewToShow: Homepage(),
      );

    case ResetPasswordRoute:
      return _getPageRoute(
        routeName: settings.name ?? "",
        viewToShow: ResetPasswordpage(),
      );

    case BookingsListRoute:
      return _getPageRoute(
        routeName: settings.name ?? "",
        viewToShow: BookingHistory(),
      );

    case BookingsRoute:
      return _getPageRoute(
        routeName: settings.name ?? "",
        viewToShow: Booking(),
      );

    case BookPageRoute:
      return _getPageRoute(
        routeName: settings.name ?? "",
        viewToShow: BookingForm(),
      );

    // case DoctorsPageRoute:
    //   return _getPageRoute(
    //     routeName: settings.name ?? "",
    //     viewToShow: AvailableDoctors(),
    //   );

    default:
      return MaterialPageRoute(
          builder: (_) => Scaffold(
                body: Center(
                    child: Text('No route defined for ${settings.name}')),
              ));
  }
}

PageRoute _getPageRoute({String routeName, @required Widget viewToShow}) {
  return MaterialPageRoute(
      settings: RouteSettings(
        name: routeName,
      ),
      builder: (_) => viewToShow);
}
