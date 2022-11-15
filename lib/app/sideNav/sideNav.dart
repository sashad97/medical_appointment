import 'package:flutter/material.dart';
import 'package:health/core/repository/auth_repo.dart';
import 'package:health/utils/constants/colors.dart';
import 'package:health/utils/constants/helpers.dart';
import 'package:health/app/widget/menuitem.dart';
import 'package:health/utils/locator.dart';
import 'package:health/utils/mixins/ui_tool_mixin.dart';
import 'package:health/utils/router/routeNames.dart';
import 'package:url_launcher/url_launcher.dart';

class SideNavpage extends StatelessWidget with UIToolMixin {
  void signout() async {
    await locator<AuthRepo>().signOut();
    navigationService.navigateReplacementTo(SignInPageRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0.0,
      child: Container(
          color: AppColors.primaryColor,
          padding: EdgeInsets.only(top: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                  child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 20),
                        alignment: Alignment.center,
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('asset/images/health.png'),
                                fit: BoxFit.fill)),
                      ),
                      Text('HEALTHCARE VQMA',
                          style: TextStyle(
                              fontSize: 14,
                              letterSpacing: 3,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white))
                    ],
                  ),
                  customYMargin(20),
                  MenuItemWidget(
                    icon: Icons.book_online,
                    title: 'My bookings',
                    onTap: () {
                      navigationService.pop();
                      navigationService.navigateTo(BookingsRoute);
                    },
                  ),
                  customYMargin(5),
                  MenuItemWidget(
                    icon: Icons.edit,
                    title: 'Change password',
                    onTap: () {
                      navigationService.pop();
                      navigationService.navigateTo(ResetPasswordRoute);
                    },
                  ),
                ],
              )),
              Column(
                children: [
                  MenuItemWidget(
                    icon: Icons.person,
                    title: 'Support',
                    onTap: () => launch("tel://+2348109954727"),
                  ),
                  customYMargin(5),
                  MenuItemWidget(
                    icon: Icons.logout,
                    title: 'LogOut',
                    onTap: () {
                      navigationService.pop();
                      signout();
                    },
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
