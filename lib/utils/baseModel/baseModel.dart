import 'package:flutter/widgets.dart';
import 'package:health/utils/locator.dart';
import 'package:health/utils/dialogeManager/dialogModels.dart';
import 'package:health/utils/dialogeManager/dialogService.dart';

class BaseModel extends ChangeNotifier {
  final ProgressService _progressService = locator<ProgressService>();
  late ProgressResponse response;

  bool _busy = false;
  bool get busy => _busy;

  void setBusy(bool value) {
    _busy = value;
    notifyListeners();
    if (value == true) {
      _progressService.loadingDialog();
    } else {
      _progressService.dialogComplete(response);
    }
  }
}
