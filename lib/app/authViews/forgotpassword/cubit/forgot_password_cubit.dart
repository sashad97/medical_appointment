import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health/core/repository/auth_repo.dart';
import 'package:health/utils/constants/enum.dart';
import 'package:health/utils/general_state/general_state.dart';

class ForgotPasswordCubit extends Cubit<AppState> {
  ForgotPasswordCubit(this._authRepo) : super(AppState.initial());
  final AuthRepo _authRepo;

  void forgotPassword(String email) async {
    emit(state.copyWith(viewState: LoadingState.loading));
    final result = await _authRepo.forgotPassword(email: email);
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
