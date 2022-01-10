import 'package:flutter/material.dart';
import 'package:health/utils/constants/colors.dart';
import 'package:health/utils/constants/helpers.dart';
import 'package:health/utils/constants/screensize.dart';
import 'package:health/utils/constants/textstyle.dart';
import 'package:health/view/homepage/homepage_vm.dart';
import 'package:health/view/sideNav/sideNav.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:provider_architecture/_viewmodel_provider.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<HomepageVm>.withConsumer(
        viewModelBuilder: () => HomepageVm(),
        onModelReady: (v) {
          v.setName();
        },
        builder: (context, model, child) {
          return Scaffold(
            backgroundColor: AppColors.white,
            key: _scaffoldKey,
            extendBodyBehindAppBar: false,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              leading: GestureDetector(
                onTap: () {
                  _scaffoldKey.currentState.openDrawer();
                },
                child: Icon(
                  Icons.menu,
                  size: 25,
                  color: AppColors.primaryColor,
                ),
              ),
              title: Text('HEALTHCARE VQMA',
                  style: titletextStyle, textAlign: TextAlign.center),
              centerTitle: true,
              elevation: 0.9,
            ),
            resizeToAvoidBottomInset: false,
            drawer: SideNavpage(),
            body: Container(
              height: Responsive.height(1, context),
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Row(
                      children: [
                        Text('welcome,',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black)),
                        customXMargin(10),
                        Text(model.name,
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor)),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () => model.navigateToForm(),
                        child: Container(
                          margin: EdgeInsets.only(bottom: 20),
                          width: Responsive.width(1, context),
                          height: Responsive.height(0.11, context),
                          decoration: BoxDecoration(
                              color: Colors.lightBlue[300],
                              borderRadius: BorderRadius.circular(10)),
                          alignment: Alignment.center,
                          child: Text(
                            'Book An Appointment',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => model.navigateToMyBooking(),
                        child: Container(
                          margin: EdgeInsets.only(bottom: 40),
                          width: Responsive.width(1, context),
                          height: Responsive.height(0.11, context),
                          decoration: BoxDecoration(
                              color: Colors.lightBlue[300],
                              borderRadius: BorderRadius.circular(10)),
                          alignment: Alignment.center,
                          child: Text(
                            'My bookings',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
