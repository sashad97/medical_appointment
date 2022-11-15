import 'package:health/utils/dialogeManager/dialogModels.dart';
import 'package:health/utils/dialogeManager/dialogService.dart';
import 'package:health/utils/locator.dart';
import 'package:health/utils/router/navigationService.dart';

mixin UIToolMixin {
  final NavigationService navigationService = locator<NavigationService>();
  final ProgressService progressService = locator<ProgressService>();
  final ProgressResponse response = ProgressResponse(confirmed: true);
}
