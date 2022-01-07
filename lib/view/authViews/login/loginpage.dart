import 'package:flutter/material.dart';
import 'package:health/utils/constants/helpers.dart';
import 'package:health/view/widget/generalButton.dart';
import 'package:health/view/widget/text_form.dart';
import 'package:health/utils/constants/colors.dart';
import 'package:health/utils/constants/screensize.dart';
import 'package:health/utils/constants/textstyle.dart';
import 'package:health/utils/constants/validator.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:stacked/stacked.dart';
import 'loginpage_view_model.dart';

class LogInPage extends StatefulWidget {
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LogInPageModel>.reactive(
        viewModelBuilder: () => LogInPageModel(),
        builder: (context, model, child) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SafeArea(
                child: Scaffold(
                    body: SingleChildScrollView(
                        child: Container(
                            decoration:
                                BoxDecoration(color: AppColors.primaryColor),
                            height: Responsive.height(1, context),
                            width: Responsive.width(1, context),
                            child: Column(children: <Widget>[
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 30),
                                width: Responsive.width(1, context),
                                decoration: BoxDecoration(
                                    // gradient: LinearGradient(
                                    //   begin: Alignment.topCenter,
                                    //   colors: [
                                    //     AppColors.loadingColor200,
                                    //     AppColors.loadingColor,
                                    //     AppColors.loadingColor100,
                                    //   ],
                                    // ),
                                    // borderRadius: BorderRadius.only(
                                    //     bottomRight: Radius.circular(50)),
                                    ),
                                child: Column(
                                  // crossAxisAlignment: CrossA,
                                  children: [
                                    Image.asset(
                                      'asset/images/health.png',
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.2,
                                      alignment: Alignment.center,
                                    ),
                                    Text('HEALTH',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                            wordSpacing: 5,
                                            letterSpacing: 5),
                                        textAlign: TextAlign.left),
                                  ],
                                ),
                              ),
                              Expanded(
                                  child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  // borderRadius: BorderRadius.only(
                                  //     topLeft: Radius.circular(0),
                                  //     topRight: Radius.circular(50)),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                  child: Form(
                                    key: formKey,
                                    child: ListView(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        children: [
                                          SizedBox(
                                            height: 50,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10.0),
                                            child: Text('LOGIN',
                                                style: headertextStyle,
                                                textAlign: TextAlign.left),
                                          ),
                                          SizedBox(height: 5),
                                          CustomTextFormField(
                                            hasPrefixIcon: true,
                                            prefixIcon: Icon(Icons.mail,
                                                color: AppColors.grey),
                                            label: "Email",
                                            borderStyle: BorderStyle.solid,
                                            textInputType:
                                                TextInputType.emailAddress,
                                            controller: emailController,
                                            onChanged: (value) {
                                              model.email = value;
                                            },
                                            validator: emailValidator,
                                          ),
                                          CustomTextFormField(
                                            label: "Password",
                                            hasPrefixIcon: true,
                                            prefixIcon: Icon(Icons.lock,
                                                color: AppColors.grey),
                                            borderStyle: BorderStyle.solid,
                                            textInputType:
                                                TextInputType.visiblePassword,
                                            obscured: model.visiblePassword,
                                            hasSuffixIcon:
                                                true, // suffix icon enabled
                                            controller: passwordController,
                                            suffixIcon: IconButton(
                                              onPressed: () {
                                                model.setvisiblePassword();
                                              }, // changes the password visibility
                                              icon: Icon(
                                                model.visiblePassword
                                                    ? Icons.visibility_off
                                                    : Icons.visibility,
                                                color: AppColors.grey_light,
                                              ),
                                            ),
                                            onChanged: (value) {
                                              model.password = value;
                                            },
                                            validator: (value) {
                                              return (value?.isEmpty ?? false)
                                                  ? 'enter password'
                                                  : null;
                                            },
                                          ),
                                          customYMargin(30),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 20),
                                              child: InkWell(
                                                onTap: () {
                                                  model.forgetPasswordDialog(
                                                      context);
                                                },
                                                child: Text(
                                                  'Forgot password?',
                                                  style: TextStyle(
                                                    color:
                                                        AppColors.primaryColor,
                                                    // fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          customYMargin(30),
                                          CustomButton(
                                              child: Text('Login',
                                                  style: buttonTextStyle),
                                              onPressed: () {
                                                FocusScope.of(context)
                                                    .unfocus();
                                                model.submit(formKey);
                                              }),
                                          SizedBox(height: 5),
                                          SizedBox(
                                              height: Responsive.sizeboxheight(
                                                  context)),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                'Don\'t have an account?  ',
                                                style: TextStyle(
                                                    color: AppColors.black),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  model.navigateToSignUp();
                                                },
                                                child: Text(
                                                  'Sign Up',
                                                  style: TextStyle(
                                                    color:
                                                        AppColors.primaryColor,
                                                    // fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ]),
                                  ),
                                ),
                              )),
                            ]))))),
          );
        });
  }
}
