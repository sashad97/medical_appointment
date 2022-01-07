import 'package:health/core/services/auth_service.dart';
import 'package:health/utils/baseModel/baseModel.dart';
import 'package:health/utils/constants/locator.dart';
import 'package:health/utils/router/navigationService.dart';
import 'package:health/utils/router/routeNames.dart';
import 'package:url_launcher/url_launcher.dart';

class SideNavViewModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthService _authentication = locator<AuthService>();

  void pop() {
    _navigationService.pop();
  }

  void navigateToMyBooking() {
    _navigationService.navigateTo(BookingsRoute);
  }

  void navigateToResetPassword() {
    _navigationService.navigateTo(ResetPasswordRoute);
  }

  call() {
    return launch("tel://+2348035853226");
  }

  void signout() {
    _authentication.signOut();
    _navigationService.navigateReplacementTo(SignInPageRoute);
  }
}
