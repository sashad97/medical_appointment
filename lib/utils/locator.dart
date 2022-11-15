import 'package:get_it/get_it.dart';
import 'package:health/app/authViews/SignUp/bloc/signup_bloc.dart';
import 'package:health/app/authViews/forgotpassword/cubit/forgot_password_cubit.dart';
import 'package:health/app/authViews/login/bloc/login_bloc.dart';
import 'package:health/app/authViews/resetpassword/cubit/reset_password_cubit.dart';
import 'package:health/app/booking_form/cubit/booking_form_cubit.dart';
import 'package:health/app/booking_history/cubit/booking_history_cubit.dart';
import 'package:health/app/view_more_info/bloc/view_more_info_bloc.dart';
import 'package:health/core/local_data_request/local_data_request.dart';
import 'package:health/core/repository/auth_repo.dart';
import 'package:health/core/repository/firestore_repo.dart';
import 'package:health/core/services/auth_data_service.dart';
import 'package:health/core/services/notification_service.dart';
import 'package:health/utils/dialogeManager/dialogService.dart';
import 'package:health/utils/router/navigationService.dart';
import 'package:health/app/splashscreens/cubit/splash_cubit.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  //services
  locator.registerLazySingleton(() => ProgressService());
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => AuthService());
  locator.registerLazySingleton(() => NotificationHelper());

  //repository
  locator.registerLazySingleton(() => LocalDataRequest());
  locator.registerLazySingleton<AuthRepo>(() => AuthRepoImpl(locator()));
  locator
      .registerLazySingleton<FireStoreRepo>(() => FireStoreRepoImpl(locator()));
  //cubit
  locator.registerLazySingleton(() => AuthCubit(locator(), locator()));
  locator.registerLazySingleton(() => ForgotPasswordCubit(locator()));
  locator.registerLazySingleton(() => ResetPasswordCubit(locator()));
  locator.registerLazySingleton(() => BookingFormCubit(locator(), locator()));
  locator.registerLazySingleton(() => BookingHistoryCubit(locator()));

  //BLOC
  locator.registerLazySingleton(() => LoginBloc(locator(), locator()));
  locator.registerLazySingleton(() => SignUpBloc(locator()));
  locator.registerLazySingleton(() => ViewMoreInfoBloc(locator(), locator()));
}
