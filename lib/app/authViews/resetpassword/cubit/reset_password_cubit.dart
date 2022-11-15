import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health/core/repository/auth_repo.dart';
import 'package:health/utils/constants/enum.dart';
import 'package:health/utils/general_state/general_state.dart';

class ResetPasswordCubit extends Cubit<AppState> {
  ResetPasswordCubit(this._authRepo) : super(AppState.initial());
  final AuthRepo _authRepo;

  void reset(String oldPassword, String newPassword) async {
    emit(state.copyWith(viewState: LoadingState.loading));
    final result = await _authRepo.resetPassword(
        oldPassword: oldPassword, newPassword: newPassword);
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
