import 'package:flutter/material.dart';
import 'package:health/utils/constants/colors.dart';
import 'package:health/utils/constants/helpers.dart';
import 'package:health/utils/constants/screensize.dart';
import 'package:health/utils/constants/textstyle.dart';
import 'package:health/view/booking_history/booking_history.dart';
import 'package:health/view/bookings/bookings_vm.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:provider_architecture/_viewmodel_provider.dart';

class Booking extends StatefulWidget {
  @override
  _BookingState createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<BookingVm>.withConsumer(
        viewModelBuilder: () => BookingVm(),
        builder: (context, model, child) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: AppColors.primaryColor,
              automaticallyImplyLeading: false,
              leading: IconButton(
                onPressed: () {
                  model.pop();
                },
                icon: Icon(Icons.arrow_back_ios, color: Colors.white),
              ),
              title: Text(
                'My Bookings',
                textAlign: TextAlign.center,
                style: newTitletextStyle,
              ),
              centerTitle: true,
            ),
            body: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BookingHistory(
                                  isCritical: false, title: "Non-Critical")));
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      width: Responsive.width(1, context),
                      height: 100,
                      decoration: BoxDecoration(
                          color: Colors.lightBlue[300],
                          boxShadow: [
                            BoxShadow(blurRadius: 4, color: Colors.black26)
                          ],
                          borderRadius: BorderRadius.circular(10)),
                      alignment: Alignment.center,
                      child: Text(
                        'Non-Critical Appointments',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                  ),
                  customYMargin(10),
                  GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BookingHistory(
                                isCritical: true, title: "Critical"))),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      width: Responsive.width(1, context),
                      height: 100,
                      decoration: BoxDecoration(
                          color: Colors.lightBlue[300],
                          boxShadow: [
                            BoxShadow(blurRadius: 4, color: Colors.black26)
                          ],
                          borderRadius: BorderRadius.circular(10)),
                      alignment: Alignment.center,
                      child: Text(
                        'Critical Appointments',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
