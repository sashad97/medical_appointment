import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health/app/authViews/SignUp/bloc/signup_bloc.dart';
import 'package:health/app/authViews/SignUp/event/signup_event.dart';
import 'package:health/utils/constants/enum.dart';
import 'package:health/utils/constants/helpers.dart';
import 'package:health/utils/general_state/general_state.dart';
import 'package:health/utils/mixins/ui_tool_mixin.dart';
import 'package:health/app/widget/generalButton.dart';
import 'package:health/app/widget/text_form.dart';
import 'package:health/utils/constants/colors.dart';
import 'package:health/utils/constants/screensize.dart';
import 'package:health/utils/constants/textstyle.dart';
import 'package:health/utils/constants/validator.dart';
import 'package:health/utils/router/routeNames.dart';

class SignUpView extends StatefulWidget {
  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> with UIToolMixin {
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  // String email = "", password = "", userName = "", phoneNumber = "";
  bool _visiblePassword = true;
  bool get visiblePassword => _visiblePassword;
  setvisiblePassword() {
    setState(() {
      _visiblePassword = !_visiblePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpBloc, AppState>(
        listener: (context, state) {
          if (state.viewState.isLoading) {
            appPrint('loading');
            progressService.loadingDialog();
          } else if (state.viewState.isIdle) {
            appPrint('not loading');
            progressService.dialogComplete(response);
            progressService.showDialog(
                title: state.response!.title ?? "",
                description: state.response!.message ?? "",
                onPressed: () => navigationService.pop());
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
              body: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.only(top: 20),
                decoration: BoxDecoration(color: AppColors.primaryColor),
                // height: Responsive.height(1, context),
                // width: Responsive.width(1, context),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 30),
                        width: Responsive.width(0.4, context),
                        child: Image.asset(
                          'asset/images/health.png',
                          height: MediaQuery.of(context).size.height * 0.1,
                          alignment: Alignment.center,
                        ),
                      ),
                      Text('HEALTHCARE VQMA',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              wordSpacing: 5,
                              letterSpacing: 3),
                          textAlign: TextAlign.left),
                      Container(
                        alignment: Alignment.bottomCenter,
                        margin: EdgeInsets.only(top: 20),
                        height: Responsive.height(0.7, context),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          // borderRadius: BorderRadius.only(
                          //     topLeft: Radius.circular(50),
                          //     topRight: Radius.circular(50)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                          child: Form(
                            key: formKey,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            child: ListView(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                children: [
                                  customYMargin(20),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Text('SIGN UP',
                                          style: headertextStyle,
                                          textAlign: TextAlign.left),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  CustomTextFormField(
                                    hasPrefixIcon: true,
                                    prefixIcon: Icon(Icons.person,
                                        color: AppColors.grey),
                                    label: "Full Name",
                                    borderStyle: BorderStyle.solid,
                                    textInputType: TextInputType.emailAddress,
                                    controller: nameController,
                                    validator: (value) {
                                      return (value?.isEmpty ?? false)
                                          ? 'field cannot be empty'
                                          : null;
                                    },
                                  ),
                                  CustomTextFormField(
                                    hasPrefixIcon: true,
                                    prefixIcon:
                                        Icon(Icons.mail, color: AppColors.grey),
                                    label: "Email",
                                    borderStyle: BorderStyle.solid,
                                    textInputType: TextInputType.emailAddress,
                                    controller: emailController,
                                    validator: emailValidator,
                                  ),
                                  CustomTextFormField(
                                    hasPrefixIcon: true,
                                    prefixIcon: Icon(Icons.phone,
                                        color: AppColors.grey),
                                    label: "Phone number",
                                    borderStyle: BorderStyle.solid,
                                    textInputType: TextInputType.text,
                                    controller: phoneController,
                                    validator: phoneValidator,
                                  ),
                                  CustomTextFormField(
                                    hasPrefixIcon: true,
                                    prefixIcon:
                                        Icon(Icons.lock, color: AppColors.grey),
                                    label: "Password",
                                    borderStyle: BorderStyle.solid,
                                    textInputType:
                                        TextInputType.visiblePassword,
                                    obscured: visiblePassword,
                                    hasSuffixIcon: true, // suffix icon enabled
                                    controller: passwordController,
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
                                    validator: passwordValidator,
                                  ),
                                  customYMargin(30),
                                  CustomButton(
                                      child: Text('Sign Up',
                                          style: buttonTextStyle),
                                      onPressed: () {
                                        FocusScope.of(context).unfocus();
                                        if (validate(formKey)) {
                                          context.read<SignUpBloc>().add(
                                              RegisterUserEvent(
                                                  password:
                                                      passwordController
                                                          .text
                                                          .trim(),
                                                  email: emailController.text
                                                      .trim(),
                                                  name: nameController.text
                                                      .trim(),
                                                  phoneNumber: phoneController
                                                      .text
                                                      .trim()));
                                        }
                                      }),
                                  SizedBox(height: 5),
                                  SizedBox(
                                      height:
                                          Responsive.sizeboxheight(context)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        'Already have an account?  ',
                                        style:
                                            TextStyle(color: AppColors.black),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          navigationService
                                              .navigateReplacementTo(
                                                  SignInPageRoute);
                                        },
                                        child: Text(
                                          'Sign In',
                                          style: TextStyle(
                                            color: AppColors.primaryColor,
                                            // fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ]),
                          ),
                        ),
                      )
                    ])),
          )),
        ));
  }
}
