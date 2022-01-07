//simport 'package:health/core/services/firestoreServices.dart';
import 'package:health/core/services/auth_service.dart';
import 'package:health/utils/baseModel/baseModel.dart';
import 'package:health/utils/constants/locator.dart';
import 'package:health/utils/router/navigationService.dart';
import 'package:health/utils/router/routeNames.dart';

class HomepageVm extends BaseModel {
  // final FireStoreService _firestoreService = locator<FireStoreService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthService _authentication = locator<AuthService>();

  String _name = '';
  String get name => _name;
  setName() {
    _name = _authentication.name;
    notifyListeners();
  }

  // recentsales() {
  //   return _firestoreService.getRecentlyBook();
  // }

  void navigateToForm() {
    _navigationService.navigateTo(BookPageRoute);
  }

  void navigateToMyBooking() {
    _navigationService.navigateTo(BookingsRoute);
  }

  void navigateToDoctors() {
    _navigationService.navigateTo(DoctorsPageRoute);
  }
}
