import 'package:flutter/material.dart';
import 'package:health/utils/constants/colors.dart';
import 'package:health/utils/constants/helpers.dart';
import 'package:health/view/widget/menuitem.dart';
import 'package:provider_architecture/_viewmodel_provider.dart';

import 'sideNav_view_model.dart';

class SideNavpage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<SideNavViewModel>.withConsumer(
        viewModelBuilder: () => SideNavViewModel(),
        builder: (context, model, child) {
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
                                      image:
                                          AssetImage('asset/images/health.png'),
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
                        MenuItem(
                          icon: Icons.book_online,
                          title: 'My bookings',
                          onTap: () {
                            model.pop();
                            model.navigateToMyBooking();
                          },
                        ),
                        customYMargin(5),
                        MenuItem(
                          icon: Icons.edit,
                          title: 'Change password',
                          onTap: () {
                            model.pop();
                            model.navigateToResetPassword();
                          },
                        ),
                      ],
                    )),
                    Column(
                      children: [
                        MenuItem(
                          icon: Icons.person,
                          title: 'Support',
                          onTap: () {
                            model.call();
                          },
                        ),
                        customYMargin(5),
                        MenuItem(
                          icon: Icons.logout,
                          title: 'LogOut',
                          onTap: () {
                            model.pop();
                            model.signout();
                          },
                        ),
                      ],
                    ),
                  ],
                )),
          );
        });
  }
}
