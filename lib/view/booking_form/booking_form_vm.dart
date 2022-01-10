import 'package:flutter/cupertino.dart';
import 'package:health/core/services/firestoreServices.dart';
import 'package:health/utils/baseModel/baseModel.dart';
import 'package:health/utils/constants/enum.dart';
import 'package:health/utils/constants/helpers.dart';
import 'package:health/utils/constants/locator.dart';
import 'package:health/utils/dialogeManager/dialogService.dart';
import 'package:health/utils/router/navigationService.dart';

class BookingFormVm extends BaseModel {
  final FireStoreService _firestoreService = locator<FireStoreService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final ProgressService _progressService = locator<ProgressService>();

  String _doctorId;
  String get doctorId => _doctorId;

  String _selectedItem;
  String get selectedItem => _selectedItem;

  String _importance;
  String get importance => _importance;
  set importance(String value) {
    _importance = value;
    notifyListeners();
  }

  dropDownValue(String value, String docId) {
    _selectedItem = value;
    print(_selectedItem.toString());
    _doctorId = docId;
    notifyListeners();
  }

  List<String> impt = ['Non-Critical', 'Critical'];

  void pop() {
    _navigationService.pop();
  }

  getDoctors() async* {
    await _firestoreService.getDoctors();
  }

  submitform(String purpose, BuildContext context) async {
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
        var a1 = 0.067;
        var a2 = 0.033;
        var index = impt.indexOf(importance);
        if (index == 0) {
          var data = await _firestoreService.getAllNCBK();

          if (data.docs.length < 20) {
            var n = data.docs.length;
            print('length is $n');
            //calculate Queue Status
            var qS = (sT1 * n * a1) + (r1 * a1);
            //calculate ScheduledTime;
            var duration = (sT1 * n) + (qS * sT1) + r1;
            print('duration is $duration');
            String date = DateTime.now()
                .add(Duration(minutes: duration.toInt()))
                .toString();
            print(date);
            await checkSession().then((value) async {
              await _firestoreService
                  .submitBookingNC(
                      date, importance, purpose, NoneCritical.success)
                  .whenComplete(() {
                showFlushBar(
                    title: 'Success',
                    message: 'Booking submitted',
                    context: context);
                setBusy(false);
              });
            });
          } else {
            String date = DateTime.now().toString();
            await checkSession().then((value) async {
              await _firestoreService
                  .submitBookingNC(
                      date, importance, purpose, NoneCritical.pending)
                  .whenComplete(() {
                showFlushBar(
                    title: 'Success',
                    message: 'Booking submitted',
                    context: context);
                setBusy(false);
              });
            });
          }
        } else {
          var data = await _firestoreService.getAllCBk();
          if (data.docs.length < 10) {
            var n = data.docs.length;
            print('length is $n');
            //calculate Queue Status
            var qS = (sT2 * n * a2) + (r2 * a1);
            //calculate ScheduledTime;
            var duration = (sT2 * n) + (qS * sT2) + r2;
            print('duration is $duration');
            String date = DateTime.now()
                .add(Duration(minutes: duration.toInt()))
                .toString();
            print(date);
            await checkSession().then((value) async {
              await _firestoreService
                  .submitBookingC(date, importance, purpose, Critical.success)
                  .whenComplete(() {
                showFlushBar(
                    title: 'Success',
                    message: 'Booking submitted',
                    context: context);
                setBusy(false);
              });
            });
          } else {
            String date = 'pending';
            await checkSession().then((value) async {
              await _firestoreService
                  .submitBookingC(date, importance, purpose, Critical.pending)
                  .whenComplete(() {
                showFlushBar(
                    title: 'Success',
                    message: 'Booking submitted',
                    context: context);
                setBusy(false);
              });
            });
          }
        }
      }
    } catch (e) {
      print(e);
      setBusy(false);
      _progressService.showDialog(
          title: 'Error', description: 'An error occured. Try again');
    }
  }
}
