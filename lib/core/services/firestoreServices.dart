import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:health/core/model/success_model.dart';
import 'package:health/core/services/notification_service.dart';
import 'package:health/utils/baseModel/baseModel.dart';
import 'package:health/utils/constants/enum.dart';
import 'package:health/utils/constants/helpers.dart';
import 'package:health/utils/constants/locator.dart';
import 'package:health/utils/dialogeManager/dialogService.dart';
import 'package:health/utils/router/navigationService.dart';
import 'package:uuid/uuid.dart';
import 'auth_service.dart';

class FireStoreService extends BaseModel {
  final ProgressService _progressService = locator<ProgressService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final firestoreInstance = FirebaseFirestore.instance;
  final NotificationHelper _notificationHelper = locator<NotificationHelper>();
  final AuthService _authentication = locator<AuthService>();
  var uuid = Uuid();
  //var data = FirebaseAuth.instance.currentUser;
  Future<dynamic> submitBookingNC(String date, String importance,
      String purpose, NoneCritical nonCritical) async {
    print('the purpose is $purpose');
    checkSession().then((value) {
      String bookingDate = DateTime.now().toString();
      String notifyDate = DateTime.now().add(Duration(minutes: 5)).toString();
      var referenceId = uuid.v4();
      if (nonCritical == NoneCritical.success) {
        firestoreInstance.runTransaction((Transaction transaction) async {
          CollectionReference reference =
              firestoreInstance.collection('nCSuccessBookings');
          await reference.add({
            "dateTime": date,
            // "doctorName": doctorName,
            // "doctorId": doctorId,
            "importance": importance,
            "purpose": purpose,
            "userId": _authentication.uid,
            "userName": _authentication.name,
            "referenceId": referenceId,
            "bookingDate": bookingDate,
            "arrivalStatus": "pending"
          });
        }).then((value) async {
          var time = formatTimeOnly(date);
          DateTime notifyMe =
              DateTime.parse(date).subtract(Duration(minutes: 5));
          await _notificationHelper.createSheduledAwesome(
              date: notifyMe,
              title: _authentication.name,
              body: 'Reminder, Your Scheduled time is $time');
          await _notificationHelper.sendAndRetrieveMessage(
              title: _authentication.name,
              body: 'Your Scheduled time is $time',
              isSch: true,
              date: newFormatDate(notifyDate).toString());

          return SuccessModel(value);
        }).onError((error, stackTrace) {
          return error;
        });
      } else {
        firestoreInstance.runTransaction((Transaction transaction) async {
          CollectionReference reference =
              firestoreInstance.collection('nCPendingBookings');
          await reference.add({
            // "dateTime": date,
            // "doctorName": doctorName,
            // "doctorId": doctorId,
            "importance": importance,
            "purpose": purpose,
            "userId": _authentication.uid,
            "userName": _authentication.name,
            "referenceId": referenceId,
            "bookingDate": bookingDate,
            "arrivalStatus": "pending"
          });
        }).then((value) async {
          await _notificationHelper.sendAndRetrieveMessage(
              title: _authentication.name,
              body: 'check Booking history later for your scheduled time',
              isSch: false);
          return SuccessModel(value);
        }).onError((error, stackTrace) {
          return error;
        });
      }
    });
  }

  Future<dynamic> submitBookingC(
      String date, String importance, String purpose, Critical critical) async {
    print('the purpose is $purpose');
    checkSession().then((value) {
      var referenceId = uuid.v4();
      String bookingDate = DateTime.now().toString();
      String notifyDate = DateTime.now().add(Duration(minutes: 5)).toString();
      if (critical == Critical.success) {
        firestoreInstance.runTransaction((Transaction transaction) async {
          CollectionReference reference =
              firestoreInstance.collection('cSuccessBookings');
          await reference.add({
            "dateTime": date,
            // "doctorName": doctorName,
            // "doctorId": doctorId,
            "importance": importance,
            "purpose": purpose,
            "userId": _authentication.uid,
            "userName": _authentication.name,
            "referenceId": referenceId,
            "bookingDate": bookingDate,
            "arrivalStatus": "pending"
          });
        }).then((value) async {
          var time = formatTimeOnly(date);
          DateTime notifyMe =
              DateTime.parse(date).subtract(Duration(minutes: 5));
          await _notificationHelper.createSheduledAwesome(
              date: notifyMe,
              title: _authentication.name,
              body: 'Reminder, Your Scheduled time is $time');
          await _notificationHelper.sendAndRetrieveMessage(
              title: _authentication.name,
              body: 'Your Scheduled time is $time',
              isSch: true,
              date: newFormatDate(notifyDate).toString());
          return SuccessModel(value);
        }).onError((error, stackTrace) {
          return error;
        });
      } else {
        firestoreInstance.runTransaction((Transaction transaction) async {
          CollectionReference reference =
              firestoreInstance.collection('cPendingBookings');
          await reference.add({
            "dateTime": date,
            // "doctorName": doctorName,
            // "doctorId": doctorId,
            "importance": importance,
            "purpose": purpose,
            "userId": _authentication.uid,
            "userName": _authentication.name,
            "referenceId": referenceId,
            "bookingDate": bookingDate,
            "arrivalStatus": "pending"
          });
        }).then((value) async {
          await _notificationHelper.sendAndRetrieveMessage(
              title: _authentication.name,
              body: 'check Booking history later for your scheduled time',
              isSch: false);
          return SuccessModel(value);
        }).onError((error, stackTrace) {
          return error;
        });
      }
    });
  }

  Future<dynamic> deletePendingNC(String documentId) async {
    print(documentId);
    DocumentReference reference = FirebaseFirestore.instance
        .collection('nCPendingBookings')
        .doc(documentId);
    await reference.delete();
  }

  Future<dynamic> deletePendingC(String documentId) async {
    print(documentId);
    DocumentReference reference = FirebaseFirestore.instance
        .collection('cPendingBookings')
        .doc(documentId);
    await reference.delete();
  }

  confirmArrival(bool isCritical, String documentId) async {
    print(documentId);
    if (isCritical) {
      DocumentReference reference = FirebaseFirestore.instance
          .collection('cSuccessBookings')
          .doc(documentId);
      await reference.update({"arrivalStatus": "completed"});
      return _progressService
          .showDialog(
              title: 'Welcome',
              description: 'kindly go to the next available doctor')
          .then((value) => _navigationService.pop());
    } else {
      DocumentReference reference = FirebaseFirestore.instance
          .collection('nCSuccessBookings')
          .doc(documentId);

      await reference.update({"arrivalStatus": "completed"});
      return _progressService
          .showDialog(
              title: 'Welcome',
              description: 'kindly go to the next available doctor')
          .then((value) => _navigationService.pop());
    }
  }

  missedArrival(bool isCritical, String documentId) async {
    print(documentId);
    if (isCritical) {
      DocumentReference reference = FirebaseFirestore.instance
          .collection('cSuccessBookings')
          .doc(documentId);

      await reference.update({"arrivalStatus": "missed"});
      return _progressService.showDialog(
          title: 'Ooops!',
          description: 'Your time has ellapse. Kindly reach out to support');
    } else {
      DocumentReference reference = FirebaseFirestore.instance
          .collection('nCSuccessBookings')
          .doc(documentId);

      await reference.update({"arrivalStatus": "missed"});
      return _progressService.showDialog(
          title: 'Ooops!',
          description: 'Your time has ellapse. Kindly reach out to support');
    }
  }

  getDoctors() {
    return firestoreInstance
        .collection('doctors')
        .orderBy("patients")
        .snapshots();
  }

  getMyPendingNCBookings() {
    return FirebaseFirestore.instance
        .collection('nCPendingBookings')
        .where("userId", isEqualTo: _authentication.uid)
        .orderBy('bookingDate', descending: true)
        .snapshots();
  }

  getMySuccessNCBookings() {
    return FirebaseFirestore.instance
        .collection('nCSuccessBookings')
        .where("userId", isEqualTo: _authentication.uid)
        .orderBy('bookingDate', descending: true)
        .snapshots();
  }

  getMyPendingCBookings() {
    return FirebaseFirestore.instance
        .collection('cPendingBookings')
        .where("userId", isEqualTo: _authentication.uid)
        .orderBy('bookingDate', descending: true)
        .snapshots();
  }

  getMySuccessCBookings() {
    return FirebaseFirestore.instance
        .collection('cSuccessBookings')
        .where("userId", isEqualTo: _authentication.uid)
        .orderBy('bookingDate', descending: true)
        .snapshots();
  }

  Future<QuerySnapshot> getAllCBk() async {
    var data = await FirebaseFirestore.instance
        .collection('cSuccessBookings')
        .where("arrivalStatus", isEqualTo: "pending")
        .orderBy('bookingDate', descending: true)
        .get();
    return data;
  }

  Future<QuerySnapshot> getAllNCBK() async {
    var data = await FirebaseFirestore.instance
        .collection('nCSuccessBookings')
        .where("arrivalStatus", isEqualTo: "pending")
        .orderBy('bookingDate', descending: true)
        .get();
    return data;
  }
}
