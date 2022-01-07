import 'package:flutter/material.dart';
import 'package:health/core/services/auth_service.dart';
import 'package:health/utils/constants/helpers.dart';
import 'package:health/view/widget/generalButton.dart';
import 'package:health/view/widget/text_form.dart';
import 'package:health/utils/baseModel/baseModel.dart';
import 'package:health/utils/constants/colors.dart';
import 'package:health/utils/constants/locator.dart';
import 'package:health/utils/constants/screensize.dart';
import 'package:health/utils/constants/textstyle.dart';
import 'package:health/utils/constants/validator.dart';
import 'package:health/utils/dialogeManager/dialogService.dart';
import 'package:health/utils/router/navigationService.dart';
import 'package:health/utils/router/routeNames.dart';

class LogInPageModel extends BaseModel {
  final forgetPasswordformKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String email = '', password = '';
  bool _visiblePassword = true;
  bool get visiblePassword => _visiblePassword;
  // bool _progress= true;
  // bool get progress => _progress;
  final AuthService _authentication = locator<AuthService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final ProgressService _progressService = locator<ProgressService>();

  setvisiblePassword() {
    _visiblePassword = !_visiblePassword;
    notifyListeners();
  }

  // setProgress(){
  //   _progress = !_progress;
  //   notifyListeners();
  // }

  void submit(GlobalKey<FormState> formKey) async {
    //signIn user
    if (validate(formKey)) {
      try {
        var isConnected = await checkInternet();
        if (isConnected == false) {
          setBusy(false);
          _progressService.showDialog(
              title: 'No Connection!',
              description: 'Please check your internet connection!');
        } else {
          _authentication.signInWithEmailAndPassword(email, password);
        }
      } catch (e) {
        print(e);
      }
    }
  }

  void navigateToSignUp() {
    _navigationService.navigateReplacementTo(SignUpPageRoute);
  }

  forget(
      GlobalKey<FormState> formKey, String email, BuildContext context) async {
    if (validate(formKey)) {
      Navigator.of(context).pop();
      _progressService.loadingDialog();

      try {
        var isConnected = await checkInternet();
        if (isConnected == false) {
          _progressService.dialogComplete(response);
          _progressService.showDialog(
              title: 'No Connection!',
              description: 'Please check your internet connection!');
        } else {
          _authentication.forgotpassword(email).then((value) {
            _progressService.dialogComplete(response);
          });
        }
      } catch (e) {
        print(e);
      }
    }
  }

  void pop() {
    _navigationService.pop();
  }

  void forgetPasswordDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.cancel,
                  color: AppColors.grey,
                  size: 25,
                ),
              ),
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Forget Password',
                  style: TextStyle(
                    fontSize: 20,
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Caros',
                  ),
                ),
                SizedBox(height: Responsive.sizeboxheight(context)),
                Form(
                    key: formKey,
                    child: CustomTextFormField(
                      hasPrefixIcon: true,
                      prefixIcon: Icon(Icons.mail, color: AppColors.grey),
                      label: "Email",
                      borderStyle: BorderStyle.solid,
                      textInputType: TextInputType.emailAddress,
                      onChanged: (value) {
                        email = value;
                      },
                      validator: emailValidator,
                    )),
              ],
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CustomButton(
                    child: Text('reset', style: buttonTextStyle),
                    onPressed: () {
                      forget(formKey, email, context);
                    }),
              ),
            ],
          );
        });
  }
}
