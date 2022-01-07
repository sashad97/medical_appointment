// import 'package:firebase_auth/firebase_auth.dart';
//import 'package:health/core/services/firestoreServices.dart';
import 'package:health/utils/baseModel/baseModel.dart';
import 'package:health/utils/constants/locator.dart';
import 'package:health/utils/router/navigationService.dart';

class BookingVm extends BaseModel {
  //final FireStoreService _fireStoreService = locator<FireStoreService>();
  final NavigationService _navigationService = locator<NavigationService>();

  // String userIdentity = FirebaseAuth.instance.currentUser.uid;
  // getBookingList() {
  //   return _fireStoreService.getMyBookings();
  // }

  pop() {
    _navigationService.pop();
  }
}
