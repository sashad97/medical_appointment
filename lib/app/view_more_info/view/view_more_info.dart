import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health/app/view_more_info/event/view_more_info_event.dart';
import 'package:health/core/model/booking_model.dart';
import 'package:health/utils/constants/colors.dart';
import 'package:health/utils/constants/enum.dart';
import 'package:health/utils/constants/helpers.dart';
import 'package:health/utils/constants/screensize.dart';
import 'package:health/utils/constants/textstyle.dart';
import 'package:health/app/widget/new_button.dart';
import 'package:health/utils/general_state/general_state.dart';
import 'package:health/utils/locator.dart';
import 'package:health/utils/mixins/ui_tool_mixin.dart';
import '../bloc/view_more_info_bloc.dart';

class FullBookingDetails extends StatefulWidget {
  final dynamic snapshot;
  final bool? isApproved;
  final bool? isCritical;
  final String? docId;
  FullBookingDetails(
      {this.snapshot, this.isApproved, this.docId, this.isCritical});
  @override
  _FullBookingDetailsState createState() => _FullBookingDetailsState();
}

class _FullBookingDetailsState extends State<FullBookingDetails>
    with UIToolMixin {
  late Color arrivalC;
  ViewMoreInfoBloc _bloc = locator<ViewMoreInfoBloc>();

  @override
  Widget build(BuildContext context) {
    BookingModel data = BookingModel.fromJson(widget.snapshot);
    if (data.arrivalStatus == 'pending') {
      arrivalC = Colors.orange[400]!;
    } else if (data.arrivalStatus == 'completed') {
      arrivalC = AppColors.green;
    } else {
      arrivalC = Colors.red;
    }
    return BlocListener<ViewMoreInfoBloc, AppState>(
      bloc: _bloc,
      listener: (context, state) {
        if (state.viewState.isLoading) {
          appPrint('loading');
          progressService.loadingDialog();
        } else if (state.viewState.isIdle) {
          appPrint('not loading');
          progressService.dialogComplete(response);
          progressService.showDialog(
              title: state.response!.title,
              description: state.response!.message);
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
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: AppColors.primaryColor,
            automaticallyImplyLeading: false,
            leading: IconButton(
              onPressed: () {
                navigationService.pop();
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
                  container(title: "Priority", info: data.importance!),
                  customYMargin(10),
                  container(title: "Purpose", info: data.purpose!),
                  customYMargin(10),
                  container(
                      title: "Scheduled Time",
                      info: data.date == 'pending'
                          ? data.date
                          : formatTimeOnly(data.date)),
                  customYMargin(10),
                  container(
                      title: "Scheduled Date",
                      info: data.date == 'pending'
                          ? data.date
                          : formatDateOnly(data.date)),
                  customYMargin(10),
                  container(
                      title: "Booking Time",
                      info: formatTimeOnly(data.bookingDate)),
                  customYMargin(10),
                  container(
                      title: "Booking Date",
                      info: formatDateOnly(data.bookingDate)),
                  customYMargin(10),
                  container(title: "Booking Id", info: data.referenceId!),
                  customYMargin(10),
                  container(
                      title: "Arrival Status",
                      info: data.arrivalStatus!,
                      tC: arrivalC),
                  customYMargin(20),
                  NewCustomButton(
                      online: data.arrivalStatus == 'pending',
                      child: Text(
                          widget.isApproved!
                              ? 'Confirm Arrival'
                              : 'Get Schedule Time',
                          style: buttonTextStyle),
                      onPressed: () {
                        if (widget.isApproved!) {
                          _bloc.add(ConfirmArrivalEvent(
                              isCritical: widget.isCritical!,
                              documentId: widget.docId!,
                              arrivalStatus: data.arrivalStatus!,
                              date: data.date!));
                        } else {
                          _bloc.add(GetWaitingTimeEvent(
                              isCritical: widget.isCritical!,
                              purpose: data.purpose!,
                              importance: data.importance!,
                              documentId: widget.docId!));
                        }
                      }),
                  customYMargin(20),
                ],
              ),
            ),
          )),
    );
  }

  Widget container(
      {String title = "",
      String info = "",
      Color tC = AppColors.primaryColor}) {
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
                fontSize: 11,
                fontWeight: FontWeight.w500,
              )),
          Container(
            width: Responsive.width(0.6, context),
            child: Text(info,
                style: TextStyle(
                  fontSize: 14,
                  color: tC,
                  fontWeight: FontWeight.w700,
                )),
          ),
        ],
      ),
    );
  }
}
