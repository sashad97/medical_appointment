import 'package:flutter/material.dart';
import 'package:health/utils/constants/colors.dart';
import 'package:health/utils/constants/helpers.dart';
import 'package:health/utils/constants/screensize.dart';
import 'package:health/app/view_more_info/view/view_more_info.dart';

// ignore: must_be_immutable
class CustomHistoryTile extends StatelessWidget {
  final String? importance;
  final String? arrivalStatus;
  final String? scheduledTime;
  final String? purpose;
  final dynamic snapshot;
  final bool? isApproved;
  final bool? isCritical;
  final String? docId;
  Color? arrivalC;
  CustomHistoryTile(
      {this.arrivalStatus,
      this.importance,
      this.purpose,
      this.scheduledTime,
      this.isApproved,
      this.docId,
      this.isCritical,
      this.snapshot});
  @override
  Widget build(BuildContext context) {
    if (arrivalStatus == 'pending') {
      arrivalC = Colors.orange[400];
    } else if (arrivalStatus == 'completed') {
      arrivalC = AppColors.green;
    } else {
      arrivalC = Colors.redAccent[400];
    }
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FullBookingDetails(
                    snapshot: snapshot,
                    isApproved: isApproved!,
                    docId: docId!,
                    isCritical: isCritical!,
                  ))),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(10),
            boxShadow: [BoxShadow(blurRadius: 4, color: Colors.black26)]),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Importance- $importance',
                  style: TextStyle(color: AppColors.black),
                ),
                customYMargin(10),
                Container(
                  width: Responsive.width(0.35, context),
                  child: Text(
                    'Purpose- $purpose',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(color: AppColors.black),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Icon(Icons.info_outline, color: AppColors.black, size: 20),
                Text(
                  'Scheduled Time- $scheduledTime',
                  style: TextStyle(color: AppColors.black),
                ),
                customYMargin(10),
                Row(
                  children: [
                    Text(
                      'Arrival Status- ',
                      style: TextStyle(color: AppColors.black),
                    ),
                    Text(
                      arrivalStatus!,
                      style: TextStyle(color: arrivalC),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
