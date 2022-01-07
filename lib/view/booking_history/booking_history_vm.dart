//import 'package:firebase_auth/firebase_auth.dart';
import 'package:health/core/services/firestoreServices.dart';
import 'package:health/utils/baseModel/baseModel.dart';
import 'package:health/utils/constants/locator.dart';
import 'package:health/utils/router/navigationService.dart';

class BookingHistoryVm extends BaseModel {
  final FireStoreService _fireStoreService = locator<FireStoreService>();
  final NavigationService _navigationService = locator<NavigationService>();

  getpendingNC() {
    return _fireStoreService.getMyPendingNCBookings();
  }

  getSuccessNC() {
    return _fireStoreService.getMySuccessNCBookings();
  }

  getpendingC() {
    return _fireStoreService.getMyPendingCBookings();
  }

  getSuccessC() {
    return _fireStoreService.getMySuccessCBookings();
  }

  pop() {
    _navigationService.pop();
  }
}
