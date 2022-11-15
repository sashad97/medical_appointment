import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health/app/authViews/SignUp/bloc/signup_bloc.dart';
import 'package:health/app/authViews/login/bloc/login_bloc.dart';
import 'package:health/app/booking_form/cubit/booking_form_cubit.dart';
import 'package:health/core/services/notification_service.dart';
import 'package:health/utils/constants/colors.dart';
import 'package:health/utils/locator.dart';
import 'package:health/utils/dialogeManager/dialogService.dart';
import 'package:health/utils/router/navigationService.dart';
import 'utils/dialogeManager/dialogManager.dart';
import 'utils/router/router.dart';
import 'app/splashscreens/view/splashscreen_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark));
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final NotificationHelper _notificationHelper = locator<NotificationHelper>();
  @override
  void initState() {
    _notificationHelper.initialize();
    _notificationHelper.getFcmToken();
    _notificationHelper.createChannel();
    _notificationHelper.init();
    _notificationHelper.onMessage(context);
    _notificationHelper.onMessageOpenApp();
    _notificationHelper.onBackgroungMessage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => locator<LoginBloc>(),
        ),
        BlocProvider(
          create: (_) => locator<SignUpBloc>(),
        ),
        BlocProvider(
          create: (_) => locator<BookingFormCubit>(),
        ),
      ],
      child: MaterialApp(
        title: 'Health',
        debugShowCheckedModeBanner: false,
        builder: (context, child) => Navigator(
          key: locator<ProgressService>().progressNavigationKey,
          onGenerateRoute: (settings) => MaterialPageRoute(
            builder: (context) => ProgressManager(child: child!),
          ),
        ),
        navigatorKey: locator<NavigationService>().navigationKey,
        theme: ThemeData(
          primaryColor: AppColors.primaryColor,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          colorScheme: ColorScheme.fromSwatch()
              .copyWith(secondary: AppColors.primaryColor),
        ),
        home: SplashscreenView(),
        onGenerateRoute: generateRoute,
      ),
    );
  }
}
