import 'package:flutter/material.dart';
import 'package:health/utils/constants/helpers.dart';
import 'package:health/view/authViews/SignUp/signup_view_model.dart';
import 'package:stacked/stacked.dart';
import 'package:health/view/widget/generalButton.dart';
import 'package:health/view/widget/text_form.dart';
import 'package:health/utils/constants/colors.dart';
import 'package:health/utils/constants/screensize.dart';
import 'package:health/utils/constants/textstyle.dart';
import 'package:health/utils/constants/validator.dart';

class SignUpView extends StatefulWidget {
  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  String email = "", password = "", userName = "", phoneNumber = "";

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SignUpViewModel>.reactive(
        viewModelBuilder: () => SignUpViewModel(),
        builder: (context, model, child) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Scaffold(
                body: SingleChildScrollView(
                    child: Container(
                        padding: EdgeInsets.only(top: 20),
                        decoration:
                            BoxDecoration(color: AppColors.primaryColor),
                        height: Responsive.height(1, context),
                        width: Responsive.width(1, context),
                        child: Column(children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(top: 30),
                            width: Responsive.width(1, context),
                            child: Image.asset(
                              'asset/images/health.png',
                              height: MediaQuery.of(context).size.height * 0.2,
                              alignment: Alignment.center,
                            ),
                          ),
                          Text('HEALTH',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  wordSpacing: 5,
                                  letterSpacing: 5),
                              textAlign: TextAlign.left),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(top: 20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                // borderRadius: BorderRadius.only(
                                //     topLeft: Radius.circular(50),
                                //     topRight: Radius.circular(50)),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 0, 15, 15),
                                child: Form(
                                  key: formKey,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  child: ListView(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: Text('SIGN UP',
                                              style: headertextStyle,
                                              textAlign: TextAlign.left),
                                        ),
                                        SizedBox(height: 5),
                                        CustomTextFormField(
                                          hasPrefixIcon: true,
                                          prefixIcon: Icon(Icons.person,
                                              color: AppColors.grey),
                                          label: "Name",
                                          borderStyle: BorderStyle.solid,
                                          textInputType:
                                              TextInputType.emailAddress,
                                          controller: nameController,
                                          onChanged: (value) {
                                            userName = value;
                                          },
                                          validator: (value) {
                                            return (value?.isEmpty ?? false)
                                                ? 'field cannot be empty'
                                                : null;
                                          },
                                        ),
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
                                            email = value;
                                          },
                                          validator: emailValidator,
                                        ),
                                        CustomTextFormField(
                                          hasPrefixIcon: true,
                                          prefixIcon: Icon(Icons.mail,
                                              color: AppColors.grey),
                                          label: "Phone number",
                                          borderStyle: BorderStyle.solid,
                                          textInputType: TextInputType.text,
                                          controller: phoneController,
                                          onChanged: (value) {
                                            phoneNumber = value;
                                          },
                                          validator: phoneValidator,
                                        ),
                                        CustomTextFormField(
                                          hasPrefixIcon: true,
                                          prefixIcon: Icon(Icons.lock,
                                              color: AppColors.grey),
                                          label: "Password",
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
                                            password = value;
                                          },
                                          validator: passwordValidator,
                                        ),
                                        customYMargin(30),
                                        CustomButton(
                                            child: Text('Sign Up',
                                                style: buttonTextStyle),
                                            onPressed: () {
                                              FocusScope.of(context).unfocus();
                                              model.submit(
                                                  formKey,
                                                  email,
                                                  password,
                                                  userName,
                                                  phoneNumber);
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
                                              'Already have an account?  ',
                                              style: TextStyle(
                                                  color: AppColors.black),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                model.navigateToSignUp();
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
                            ),
                          )
                        ])))),
          );
        });
  }
}
