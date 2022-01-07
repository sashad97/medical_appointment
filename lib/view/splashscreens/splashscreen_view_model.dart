import 'package:health/core/services/auth_service.dart';
import 'package:health/utils/baseModel/baseModel.dart';
import 'package:health/utils/constants/locator.dart';

class SplashscreenViewModel extends BaseModel {
  final AuthService _authentication = locator<AuthService>();

  isuserloggedin() {
    return _authentication.getCurrentUser();
  }
}
