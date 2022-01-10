import 'package:flutter/cupertino.dart';
//import 'package:health/core/services/auth_service.dart';
import 'package:health/core/services/firestoreServices.dart';
// import 'package:health/core/services/notification_service.dart';
import 'package:health/utils/baseModel/baseModel.dart';
import 'package:health/utils/constants/enum.dart';
import 'package:health/utils/constants/helpers.dart';
import 'package:health/utils/constants/locator.dart';
import 'package:health/utils/dialogeManager/dialogService.dart';
import 'package:health/utils/router/navigationService.dart';

class ViewMoreInfoVm extends BaseModel {
  final FireStoreService _firestoreService = locator<FireStoreService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final ProgressService _progressService = locator<ProgressService>();
  // final NotificationHelper _notificationHelper = locator<NotificationHelper>();
  // final AuthService _authentication = locator<AuthService>();

  getWaitingTimeform(
      {bool isCritical,
      String purpose,
      String importance,
      String documentId,
      BuildContext context}) async {
    setBusy(true);
    try {
      var isConnected = await checkInternet();
      if (isConnected == false) {
        setBusy(false);
        _progressService.showDialog(
            title: 'No Connection!',
            description: 'Please check your internet connection!');
      } else {
        var sT1 = 15;
        var sT2 = 25;
        var r1 = 0.5 * sT1;
        var r2 = 0.5 * sT2;
        var a1 = 0.1;
        var a2 = 0.033;
        if (!isCritical) {
          var data = await _firestoreService.getAllNCBK();
          if (data.docs.length < 20) {
            var n = data.docs.length;
            //calculate Queue Status
            var qS = (sT1 * n * a1) + (r1 * a1);
            //calculate ScheduledTime;
            var duration = (sT1 * n) + (qS * sT1) + r1;
            String date = DateTime.now()
                .add(Duration(minutes: duration.toInt()))
                .toString();
            //var time = formatTimeOnly(date);
            await checkSession().then((value) async {
              await _firestoreService
                  .submitBookingNC(
                      date, importance, purpose, NoneCritical.success)
                  .then((value) async {
                await _firestoreService.deletePendingNC(documentId);
                showFlushBar(
                    title: 'Success',
                    message: 'Schedule time would be recieved shortly',
                    context: context);
                setBusy(false);
              });
            });
          } else {
            await checkSession().then((value) async {
              setBusy(false);
              _progressService.showDialog(
                  title: 'Sorry',
                  description: 'No Available slots. check back later');
            });
          }
        } else {
          var data = await _firestoreService.getAllCBk();
          if (data.docs.length < 10) {
            var n = data.docs.length;
            //calculate Queue Status
            var qS = (sT2 * n * a2) + (r2 * a1);
            //calculate ScheduledTime;
            var duration = (sT2 * n) + (qS * sT2) + r2;
            String date = DateTime.now()
                .add(Duration(minutes: duration.toInt()))
                .toString();
            //var time = formatTimeOnly(date);
            await checkSession().then((value) async {
              await _firestoreService
                  .submitBookingC(date, importance, purpose, Critical.success)
                  .then((value) async {
                await _firestoreService.deletePendingC(documentId);
                showFlushBar(
                    title: 'Success',
                    message: 'Schedule time would be recieved shortly',
                    context: context);
                setBusy(false);
              });
            });
          } else {
            await checkSession().then((value) async {
              setBusy(false);
              _progressService.showDialog(
                  title: 'Sorry',
                  description: 'No Available slots. check back later');
            });
          }
        }
      }
    } catch (e) {
      print(e);
      setBusy(false);
      showFlushBar(
          title: 'Error',
          message: 'An error occured, try again',
          context: context);
    }
  }

  confirmArrival(bool isCritical, documentId, String date, String arrivalStatus,
      BuildContext context) async {
    setBusy(true);
    try {
      if (arrivalStatus == "completed") {
        _progressService.showDialog(
            title: 'Ooops!', description: 'Slot has already been used');
      } else {
        int d = DateTime.now().difference(DateTime.parse(date)).inMinutes;
        setBusy(true);
        var isConnected = await checkInternet();
        if (isConnected == false) {
          setBusy(false);
          _progressService.showDialog(
              title: 'No Connection!',
              description: 'Please check your internet connection!');
        } else {
          await checkSession().then((value) async {
            if (d >= 0 && d <= 20) {
              await _firestoreService.confirmArrival(isCritical, documentId);
              setBusy(false);
            } else if (d < 0) {
              await _progressService.showDialog(
                  title: 'Ooops!',
                  description: 'its not yet time. wait a little.');
              setBusy(false);
            } else {
              await _firestoreService.missedArrival(isCritical, documentId);
              setBusy(false);
            }
          });
        }
      }
    } catch (e) {
      print(e);
      setBusy(false);
      showFlushBar(
          title: 'Error',
          message: 'An error occured, try again',
          context: context);
    }
  }

  pop() {
    _navigationService.pop();
  }
}
