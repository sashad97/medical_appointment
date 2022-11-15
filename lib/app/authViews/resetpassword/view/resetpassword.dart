import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health/app/authViews/resetpassword/cubit/reset_password_cubit.dart';
import 'package:health/app/widget/generalButton.dart';
import 'package:health/app/widget/text_form.dart';
import 'package:health/utils/constants/colors.dart';
import 'package:health/utils/constants/enum.dart';
import 'package:health/utils/constants/helpers.dart';
import 'package:health/utils/constants/screensize.dart';
import 'package:health/utils/constants/textstyle.dart';
import 'package:health/utils/constants/validator.dart';
import 'package:health/utils/general_state/general_state.dart';
import 'package:health/utils/locator.dart';
import 'package:health/utils/mixins/ui_tool_mixin.dart';

class ResetPasswordpage extends StatefulWidget {
  @override
  ResetPasswordpageState createState() => ResetPasswordpageState();
}

class ResetPasswordpageState extends State<ResetPasswordpage> with UIToolMixin {
  final formKey = GlobalKey<FormState>();
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  String oldPassword = "", newPassword = "";
  ResetPasswordCubit _cubit = locator<ResetPasswordCubit>();

  bool _visiblePassword = true;
  bool get visiblePassword => _visiblePassword;
  setvisiblePassword() {
    setState(() {
      _visiblePassword = !_visiblePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ResetPasswordCubit, AppState>(
        bloc: _cubit,
        listener: (context, state) {
          if (state.viewState.isLoading) {
            appPrint('loading');
            progressService.loadingDialog();
          } else if (state.viewState.isIdle) {
            appPrint('not loading');
            progressService.dialogComplete(response);
            navigationService.pop();
            progressService.showDialog(
                title: state.response!.title ?? "",
                description: state.response!.message ?? "");
          } else {
            appPrint('not loading');
            appPrint(state.response!.title!);
            appPrint(state.response!.message!);
            progressService.dialogComplete(response);
            progressService.showDialog(
                title: state.response!.title ?? "",
                description: state.response!.message ?? "");
          }
        },
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              automaticallyImplyLeading: false,
              leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: AppColors.white),
                  onPressed: () {
                    navigationService.pop();
                  }),
              backgroundColor: AppColors.primaryColor,
              title: Text(
                'Change Password',
                textAlign: TextAlign.center,
                style: appBartextStyle,
              ),
              centerTitle: true,
            ),
            body: ListView(children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                    key: formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: Responsive.sizeboxheight(context)),
                          CustomTextFormField(
                            label: "Old Password",
                            borderStyle: BorderStyle.solid,
                            textInputType: TextInputType.visiblePassword,
                            obscured: visiblePassword,
                            hasSuffixIcon: true, // suffix icon enabled
                            controller: oldPasswordController,
                            suffixIcon: IconButton(
                              onPressed: () {
                                setvisiblePassword();
                              }, // changes the password visibility
                              icon: Icon(
                                visiblePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: AppColors.grey_light,
                              ),
                            ),
                            onChanged: (value) {
                              oldPassword = value!;
                            },
                            validator: passwordValidator,
                          ),
                          SizedBox(height: Responsive.sizeboxheight(context)),
                          CustomTextFormField(
                            label: "New Password",
                            borderStyle: BorderStyle.solid,
                            textInputType: TextInputType.visiblePassword,
                            obscured: visiblePassword,
                            hasSuffixIcon: true, // suffix icon enabled
                            controller: newPasswordController,
                            suffixIcon: IconButton(
                              onPressed: () {
                                setvisiblePassword();
                              }, // changes the password visibility
                              icon: Icon(
                                visiblePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: AppColors.grey_light,
                              ),
                            ),
                            onChanged: (value) {
                              newPassword = value!;
                            },
                            validator: passwordValidator,
                          ),
                        ])),
              ),
              SizedBox(height: Responsive.sizeboxheight(context) * 2),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CustomButton(
                    child: Text('Change Password', style: buttonTextStyle),
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      if (validate(formKey)) {
                        _cubit.reset(oldPassword, newPassword);
                      }
                    }),
              ),
            ]),
          ),
        ));
  }
}
