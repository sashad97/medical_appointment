import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health/app/authViews/SignUp/event/signup_event.dart';
import 'package:health/core/repository/auth_repo.dart';
import 'package:health/utils/constants/enum.dart';
import 'package:health/utils/dialogeManager/dialogModels.dart';
import 'package:health/utils/general_state/general_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, AppState> {
  SignUpBloc(
    AuthRepo authRepo,
  )   : _authRepo = authRepo,
        super(AppState.initial()) {
    on<RegisterUserEvent>(_onSignUp);
  }
  final AuthRepo _authRepo;
  late ProgressResponse response;

  void _onSignUp(
    RegisterUserEvent event,
    Emitter<AppState> emit,
  ) async {
    emit(state.copyWith(viewState: LoadingState.loading));
    final result = await _authRepo.signUp(
        email: event.email,
        password: event.password,
        userName: event.name,
        phoneNumber: event.phoneNumber);
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
