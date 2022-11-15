import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health/app/authViews/login/event/login_event.dart';
import 'package:health/core/model/base_response.dart';
import 'package:health/core/repository/auth_repo.dart';
import 'package:health/core/services/auth_data_service.dart';
import 'package:health/utils/constants/enum.dart';
import 'package:health/utils/constants/helpers.dart';
import 'package:health/utils/general_state/general_state.dart';

class LoginBloc extends Bloc<LoginEvent, AppState> {
  LoginBloc(AuthRepo authRepo, AuthService authService)
      : _authRepo = authRepo,
        _authService = authService,
        super(AppState.initial()) {
    on<LoginInUserEvent>(_onLogin);
  }
  final AuthRepo _authRepo;
  final AuthService _authService;

  void _onLogin(
    LoginInUserEvent event,
    Emitter<AppState> emit,
  ) async {
    try {
      emit(state.copyWith(viewState: LoadingState.loading));
      final result =
          await _authRepo.signIn(email: event.email, password: event.password);

      if (result.status!) {
        appPrint((result.data! as User).displayName!);
        _authService.newUser = result.data;
        emit(
          state.copyWith(response: result, viewState: LoadingState.idle),
        );
      } else {
        appPrint(result.message!);
        emit(
          state.copyWith(response: result, viewState: LoadingState.error),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
            response: BaseResponse(
                status: false, title: 'Ooops', message: 'an error occured'),
            viewState: LoadingState.error),
      );
    }
  }
}
