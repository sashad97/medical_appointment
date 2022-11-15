import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health/core/local_data_request/local_data_request.dart';
import 'package:health/core/local_data_request/local_url.dart';
import 'package:health/core/repository/firestore_repo.dart';
import 'package:health/core/services/auth_data_service.dart';
import 'package:health/utils/general_state/general_state.dart';
import 'package:health/utils/locator.dart';

class BookingHistoryCubit extends Cubit<AppState> {
  BookingHistoryCubit(FireStoreRepo fireStoreRepo)
      : _fireStoreRepo = fireStoreRepo,
        super(AppState.initial());
  final FireStoreRepo _fireStoreRepo;

  String get uid => locator<AuthService>().user!.uid;

  getpendingNC() {
    return _fireStoreRepo.getMyPendingNCBookings(uid);
  }

  getSuccessNC() {
    return _fireStoreRepo.getMySuccessNCBookings(uid);
  }

  getpendingC() {
    return _fireStoreRepo.getMyPendingCBookings(uid);
  }

  getSuccessC() {
    return _fireStoreRepo.getMySuccessCBookings(uid);
  }
}
