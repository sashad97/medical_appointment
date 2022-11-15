import 'package:flutter/material.dart';
import 'package:health/core/local_data_request/local_data_request.dart';
import 'package:health/core/local_data_request/local_url.dart';
import 'package:health/utils/constants/colors.dart';
import 'package:health/utils/constants/helpers.dart';
import 'package:health/utils/constants/screensize.dart';
import 'package:health/utils/constants/textstyle.dart';
import 'package:health/app/sideNav/sideNav.dart';
import 'package:health/utils/locator.dart';
import 'package:health/utils/mixins/ui_tool_mixin.dart';
import 'package:health/utils/router/routeNames.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

// void navigateToDoctors() {
//   _navigationService.navigateTo(DoctorsPageRoute);
// }

class _HomepageState extends State<Homepage> with UIToolMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  final LocalDataRequest _dataRequest = locator<LocalDataRequest>();
  String name = "";

  setName() async {
    final d = await _dataRequest.getString(AppLocalUrl.userName);
    setState(() {
      name = d;
    });
  }

  @override
  void initState() {
    setName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      key: _scaffoldKey,
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            _scaffoldKey.currentState!.openDrawer();
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
                  Text(name,
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
                  onTap: () => navigationService.navigateTo(BookPageRoute),
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
                  onTap: () => navigationService.navigateTo(BookingsRoute),
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
  }
}
