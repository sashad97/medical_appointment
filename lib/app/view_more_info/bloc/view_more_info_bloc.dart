import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health/app/view_more_info/event/view_more_info_event.dart';
import 'package:health/core/local_data_request/local_data_request.dart';
import 'package:health/core/local_data_request/local_url.dart';
import 'package:health/core/model/base_response.dart';
import 'package:health/core/model/booking_model.dart';
import 'package:health/core/repository/firestore_repo.dart';
import 'package:health/utils/constants/enum.dart';
import 'package:health/utils/general_state/general_state.dart';
import 'package:uuid/uuid.dart';

class ViewMoreInfoBloc extends Bloc<ViewMoreInfoEvent, AppState> {
  ViewMoreInfoBloc(
      FireStoreRepo fireStoreRepo, LocalDataRequest localDataRequest)
      : _fireStoreRepo = fireStoreRepo,
        _dataRequest = localDataRequest,
        super(AppState.initial()) {
    on<GetWaitingTimeEvent>(_onGetWaitingTime);
    on<ConfirmArrivalEvent>(_onConfirmArrivalEvent);
  }
  final FireStoreRepo _fireStoreRepo;
  final LocalDataRequest _dataRequest;

  void _onGetWaitingTime(
    GetWaitingTimeEvent event,
    Emitter<AppState> emit,
  ) async {
    emit(state.copyWith(viewState: LoadingState.loading));
    var sT1 = 15;
    var sT2 = 25;
    var r1 = 0.5 * sT1;
    var r2 = 0.5 * sT2;
    var a1 = 0.1;
    var a2 = 0.033;
    String bookingDate = DateTime.now().toString();
    String ref = Uuid().v4();
    String uid = _dataRequest.getString(AppLocalUrl.userId);
    String name = _dataRequest.getString(AppLocalUrl.userName);
    if (!event.isCritical) {
      var data = await _fireStoreRepo.getAllNCBK();
      if (data.docs.length < 20) {
        var n = data.docs.length;
        //calculate Queue Status
        var qS = (sT1 * n * a1) + (r1 * a1);
        //calculate ScheduledTime;
        var duration = (sT1 * n) + (qS * sT1) + r1;
        String date =
            DateTime.now().add(Duration(minutes: duration.toInt())).toString();
        BookingModel submitData = BookingModel(
            date: date,
            importance: event.importance,
            purpose: event.purpose,
            arrivalStatus: 'pending',
            bookingDate: bookingDate,
            referenceId: ref,
            uid: uid,
            name: name);

        final result = await _fireStoreRepo.submitBookingNC(
            nonCritical: NoneCritical.success, data: submitData);
        if (result.status!) {
          await _fireStoreRepo.deletePendingNC(event.documentId);
          result.message = 'Schedule time would be recieved shortly';
          emit(
            state.copyWith(response: result, viewState: LoadingState.idle),
          );
        } else {
          emit(
            state.copyWith(response: result, viewState: LoadingState.error),
          );
        }
      } else {
        final response = BaseResponse(
            status: false,
            message: 'No Available slots. check back later',
            title: 'Sorry');
        emit(
          state.copyWith(response: response, viewState: LoadingState.idle),
        );
      }
    } else {
      var data = await _fireStoreRepo.getAllCBk();
      if (data.docs.length < 10) {
        var n = data.docs.length;
        //calculate Queue Status
        var qS = (sT2 * n * a2) + (r2 * a1);
        //calculate ScheduledTime;
        var duration = (sT2 * n) + (qS * sT2) + r2;
        String date =
            DateTime.now().add(Duration(minutes: duration.toInt())).toString();
        BookingModel submitData = BookingModel(
            date: date,
            importance: event.importance,
            purpose: event.purpose,
            arrivalStatus: 'pending',
            bookingDate: bookingDate,
            referenceId: ref,
            uid: uid,
            name: name);
        final result = await _fireStoreRepo.submitBookingC(
            data: submitData, critical: Critical.success);

        if (result.status!) {
          await _fireStoreRepo.deletePendingNC(event.documentId);
          result.message = 'Schedule time would be recieved shortly';
          emit(
            state.copyWith(response: result, viewState: LoadingState.idle),
          );
        } else {
          emit(
            state.copyWith(response: result, viewState: LoadingState.error),
          );
        }
      } else {
        final response = BaseResponse(
            status: false,
            message: 'No Available slots. check back later',
            title: 'Sorry');
        emit(
          state.copyWith(response: response, viewState: LoadingState.idle),
        );
      }
    }
  }

  void _onConfirmArrivalEvent(
    ConfirmArrivalEvent event,
    Emitter<AppState> emit,
  ) async {
    emit(state.copyWith(viewState: LoadingState.loading));
    if (event.arrivalStatus == "completed") {
      final response = BaseResponse(
          status: false,
          message: 'Slot has already been used',
          title: 'Ooops!');
      emit(state.copyWith(viewState: LoadingState.idle, response: response));
    } else {
      int d = DateTime.now().difference(DateTime.parse(event.date)).inMinutes;

      if (d >= 0 && d <= 20) {
        final result = await _fireStoreRepo.confirmArrival(
            isCritical: event.isCritical, documentId: event.documentId);
        if (result.status!) {
          emit(
            state.copyWith(response: result, viewState: LoadingState.idle),
          );
        } else {
          emit(
            state.copyWith(response: result, viewState: LoadingState.error),
          );
        }
      } else if (d < 0) {
        final response = BaseResponse(
            status: false,
            message: 'its not yet time. wait a little.',
            title: 'Ooops!');
        emit(state.copyWith(viewState: LoadingState.idle, response: response));
      } else {
        final result = await _fireStoreRepo.missedArrival(
            isCritical: event.isCritical, documentId: event.documentId);
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
    }
  }
}
