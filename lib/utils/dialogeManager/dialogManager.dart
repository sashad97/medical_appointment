import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:health/utils/constants/colors.dart';
import 'package:health/utils/locator.dart';
import 'package:health/utils/dialogeManager/dialogModels.dart';
import 'package:health/utils/dialogeManager/dialogService.dart';

class ProgressManager extends StatefulWidget {
  final Widget child;
  ProgressManager({Key? key, required this.child}) : super(key: key);

  _ProgressManagerState createState() => _ProgressManagerState();
}

class _ProgressManagerState extends State<ProgressManager> {
  ProgressService _progressService = locator<ProgressService>();

  @override
  void initState() {
    super.initState();
    _progressService.registerProgressListener(_showDialog);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void _showDialog(ProgressRequest request) {
    var isConfirmationDialog = request.cancelTitle.isNotEmpty;
    var dialogType = request.buttonTitle.isNotEmpty;

    if (dialogType) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(request.title),
          content: Text(request.description),
          actions: <Widget>[
            if (isConfirmationDialog)
              TextButton(
                child: Text(request.cancelTitle),
                onPressed: () {
                  _progressService
                      .dialogComplete(ProgressResponse(confirmed: false));
                },
              ),
            TextButton(
              child: Text(request.buttonTitle),
              onPressed: () {
                _progressService
                    .dialogComplete(ProgressResponse(confirmed: true));
                request.onpressed!();
              },
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => Center(
          child: Container(
              alignment: Alignment.center,
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [BoxShadow(blurRadius: 4)]),
              child: SpinKitCubeGrid(
                color: AppColors.loadingColor200,
                size: 40,
              )),
        ),
      );
    }
  }
}
