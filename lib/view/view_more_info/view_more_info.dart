import 'package:flutter/material.dart';
import 'package:health/utils/constants/colors.dart';
import 'package:health/utils/constants/helpers.dart';
import 'package:health/utils/constants/screensize.dart';
import 'package:health/utils/constants/textstyle.dart';
import 'package:health/view/view_more_info/view_morre_info_vm.dart';
import 'package:health/view/widget/new_button.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:provider_architecture/_viewmodel_provider.dart';

class FullBookingDetails extends StatefulWidget {
  final dynamic snapshot;
  final bool isApproved;
  final bool isCritical;
  final String docId;
  FullBookingDetails(
      {this.snapshot, this.isApproved, this.docId, this.isCritical});
  @override
  _FullBookingDetailsState createState() => _FullBookingDetailsState();
}

class _FullBookingDetailsState extends State<FullBookingDetails> {
  Color arrivalC;
  @override
  Widget build(BuildContext context) {
    var data = widget.snapshot;
    if (data["arrivalStatus"] == 'pending') {
      arrivalC = Colors.orange[400];
    } else if (data["arrivalStatus"] == 'completed') {
      arrivalC = AppColors.green;
    } else {
      arrivalC = Colors.red;
    }
    return ViewModelProvider<ViewMoreInfoVm>.withConsumer(
        viewModelBuilder: () => ViewMoreInfoVm(),
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
                  'Full Details',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                centerTitle: true,
              ),
              body: SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: [
                      customYMargin(20),
                      container(title: "Importance", info: data["importance"]),
                      customYMargin(10),
                      container(title: "Purpose", info: data["purpose"]),
                      customYMargin(10),
                      container(
                          title: "Scheduled Time",
                          info: data["dateTime"] == 'pending'
                              ? data["dateTime"]
                              : formatTimeOnly(data["dateTime"])),
                      customYMargin(10),
                      container(
                          title: "Scheduled Date",
                          info: data["dateTime"] == 'pending'
                              ? data["dateTime"]
                              : formatDateOnly(data["dateTime"])),
                      customYMargin(10),
                      container(
                          title: "Booking Time",
                          info: formatTimeOnly(data["bookingDate"])),
                      customYMargin(10),
                      container(
                          title: "Booking Date",
                          info: formatDateOnly(data["bookingDate"])),
                      customYMargin(10),
                      container(title: "Booking Id", info: data["referenceId"]),
                      customYMargin(10),
                      container(
                          title: "Arrival Status",
                          info: data["arrivalStatus"],
                          tC: arrivalC),
                      customYMargin(20),
                      NewCustomButton(
                          online: data["arrivalStatus"] == 'pending',
                          child: Text(
                              widget.isApproved
                                  ? 'Confirm Arrival'
                                  : 'Get Schedule Time',
                              style: buttonTextStyle),
                          onPressed: () {
                            if (widget.isApproved) {
                              model.confirmArrival(
                                  widget.isCritical,
                                  widget.docId,
                                  data["dateTime"].toString(),
                                  data["arrivalStatus"],
                                  context);
                            } else {
                              model.getWaitingTimeform(
                                  context: context,
                                  isCritical: widget.isCritical,
                                  purpose: data["purpose"],
                                  importance: data["purpose"],
                                  documentId: widget.docId);
                            }
                          }),
                    ],
                  ),
                ),
              ));
        });
  }

  Widget container(
      {String title, String info, Color tC = AppColors.primaryColor}) {
    return Container(
      height: 60,
      width: Responsive.width(1, context),
      padding: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.grey[200]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              )),
          Container(
            width: Responsive.width(0.6, context),
            child: Text(info,
                style: TextStyle(
                  fontSize: 16,
                  color: tC,
                  fontWeight: FontWeight.w700,
                )),
          ),
        ],
      ),
    );
  }
}
