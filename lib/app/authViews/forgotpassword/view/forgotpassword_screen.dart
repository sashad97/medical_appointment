import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health/app/authViews/forgotpassword/cubit/forgot_password_cubit.dart';
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

class ForgotPassword extends Dialog with UIToolMixin {
  TextEditingController emailController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ForgotPasswordCubit _cubit = locator<ForgotPasswordCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgotPasswordCubit, AppState>(
      bloc: _cubit,
      listener: (context, state) {
        if (state.viewState.isLoading) {
          appPrint('loading');
          progressService.loadingDialog();
        } else if (state.viewState.isIdle) {
          appPrint('not loading');
          progressService.dialogComplete(response);
          navigationService.pop();
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
      child: AlertDialog(
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
                  controller: emailController,
                  borderStyle: BorderStyle.solid,
                  textInputType: TextInputType.emailAddress,
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
                  FocusScope.of(context).unfocus();
                  if (validate(formKey)) {
                    _cubit.forgotPassword(emailController.text.trim());
                  }
                }),
          ),
        ],
      ),
    );
  }
}
