import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health/core/local_data_request/local_data_request.dart';
import 'package:health/core/local_data_request/local_url.dart';
import 'package:health/core/model/base_response.dart';
import 'package:health/core/model/booking_model.dart';
import 'package:health/core/repository/firestore_repo.dart';
import 'package:health/utils/constants/enum.dart';
import 'package:health/utils/constants/helpers.dart';
import 'package:health/utils/general_state/general_state.dart';
import 'package:uuid/uuid.dart';

class BookingFormCubit extends Cubit<AppState> {
  BookingFormCubit(FireStoreRepo fireStoreRepo, LocalDataRequest dataRequest)
      : _fireStoreRepo = fireStoreRepo,
        _dataRequest = dataRequest,
        super(AppState.initial()) {
    importance = impt[0];
  }
  final FireStoreRepo _fireStoreRepo;
  final LocalDataRequest _dataRequest;

  List<String> impt = ['Non-Critical', 'Critical'];

  String? _importance = '';
  String? get importance => _importance!;
  set importance(String? value) {
    _importance = value;
    appPrint(value!);
  }

  submitform({String purpose = ""}) async {
    try {
      emit(state.copyWith(viewState: LoadingState.loading));
      var sT1 = 15;
      var sT2 = 25;
      var r1 = 0.5 * sT1;
      var r2 = 0.5 * sT2;
      var a1 = 0.067;
      var a2 = 0.033;
      var index = impt.indexOf(importance!);
      String ref = Uuid().v4();
      String bookingDate = DateTime.now().toString();
      String date = "";
      String uid = await _dataRequest.getString(AppLocalUrl.userId);
      String name = await _dataRequest.getString(AppLocalUrl.userName);
      if (index == 0) {
        final data = await _fireStoreRepo.getAllNCBK();
        bool isNCSuccess = data.docs.length < 20;
        if (isNCSuccess) {
          var n = data.docs.length;
          print('length is $n');
          //calculate Queue Status
          var qS = (sT1 * n * a1) + (r1 * a1);
          //calculate ScheduledTime;
          var duration = (sT1 * n) + (qS * sT1) + r1;
          print('duration is $duration');
          date = DateTime.now()
              .add(Duration(minutes: duration.toInt()))
              .toString();
        } else {
          // date = DateTime.now().toString();
          date = 'pending';
        }
        appPrint(date);

        BookingModel submitData = BookingModel(
            date: date,
            importance: importance,
            purpose: purpose,
            arrivalStatus: 'pending',
            bookingDate: bookingDate,
            referenceId: ref,
            uid: uid,
            name: name);
        final result = await _fireStoreRepo.submitBookingNC(
            data: submitData,
            nonCritical:
                isNCSuccess ? NoneCritical.success : NoneCritical.pending);

        if (result.status!) {
          emit(
            state.copyWith(response: result, viewState: LoadingState.idle),
          );
        } else {
          emit(
            state.copyWith(response: result, viewState: LoadingState.error),
          );
        }
      } else {
        final data = await _fireStoreRepo.getAllCBk();
        if (data.docs.length < 10) {
          var n = data.docs.length;
          print('length is $n');
          //calculate Queue Status
          var qS = (sT2 * n * a2) + (r2 * a1);
          //calculate ScheduledTime;
          var duration = (sT2 * n) + (qS * sT2) + r2;
          print('duration is $duration');
          date = DateTime.now()
              .add(Duration(minutes: duration.toInt()))
              .toString();
          appPrint(date);
        } else {
          date = 'pending';
        }
        bool isCSuccess = data.docs.length < 10;
        BookingModel submitData = BookingModel(
            date: date,
            importance: importance,
            purpose: purpose,
            arrivalStatus: 'pending',
            bookingDate: bookingDate,
            referenceId: ref,
            uid: uid,
            name: name);

        final result = await _fireStoreRepo.submitBookingC(
            data: submitData,
            critical: isCSuccess ? Critical.success : Critical.pending);
        if (result.status!) {
          emit(
            state.copyWith(response: result, viewState: LoadingState.idle),
          );
        } else {
          emit(
            state.copyWith(response: result, viewState: LoadingState.error),
          );
        }
      }
    } catch (e) {
      emit(
        state.copyWith(
            response: BaseResponse(
                title: 'error', message: 'an error occured. try again later'),
            viewState: LoadingState.error),
      );
    }
  }
}
