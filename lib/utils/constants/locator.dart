import 'package:get_it/get_it.dart';
import 'package:health/core/services/auth_service.dart';
import 'package:health/core/services/firestoreServices.dart';
import 'package:health/core/services/notification_service.dart';
import 'package:health/utils/dialogeManager/dialogService.dart';
import 'package:health/utils/router/navigationService.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  locator.registerLazySingleton(() => AuthService());
  locator.registerLazySingleton(() => ProgressService());
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => FireStoreService());
  locator.registerLazySingleton(() => NotificationHelper());
}
