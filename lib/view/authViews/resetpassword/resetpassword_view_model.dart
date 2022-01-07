import 'package:flutter/material.dart';
import 'package:health/core/services/auth_service.dart';
import 'package:health/utils/baseModel/baseModel.dart';
import 'package:health/utils/constants/helpers.dart';
import 'package:health/utils/constants/locator.dart';
import 'package:health/utils/constants/validator.dart';
import 'package:health/utils/dialogeManager/dialogService.dart';
import 'package:health/utils/router/navigationService.dart';

class ResetPasswordViewModel extends BaseModel {
  bool _visiblePassword = true;
  bool get visiblePassword => _visiblePassword;
  final AuthService _authentication = locator<AuthService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final ProgressService _progressService = locator<ProgressService>();

  setvisiblePassword() {
    _visiblePassword = !_visiblePassword;
    notifyListeners();
  }

  resetpassword(String oldPassword, String newPassword,
      GlobalKey<FormState> formKey) async {
    if (validate(formKey)) {
      try {
        var isConnected = await checkInternet();
        if (isConnected == false) {
          _progressService.showDialog(
              title: 'No Connection!',
              description: 'Please check your internet connection!');
        } else {
          _authentication.resetpassword(oldPassword, newPassword);
        }
      } catch (e) {
        print(e);
      }
    }
  }

  void pop() {
    _navigationService.pop();
  }
}
