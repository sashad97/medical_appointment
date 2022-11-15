import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health/core/repository/auth_repo.dart';
import 'package:health/app/splashscreens/state/splash_screen_state.dart';
import 'package:health/core/services/auth_data_service.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(AuthRepo authRepo, AuthService authService)
      : _authService = authService,
        _authRepo = authRepo,
        super(AuthInitial()) {
    checkAuth();
  }
  final AuthRepo _authRepo;
  final AuthService _authService;

  void checkAuth() async {
    emit(AuthLoading());
    final response = await _authRepo.getCurrentUser();
    if (response.status!) {
      _authService.newUser = response.data;
      emit(AuthAuthenticated());
    } else {
      emit(AuthUnauthenticated());
    }
  }
}
