import 'package:health/core/model/base_response.dart';
import 'package:health/utils/constants/enum.dart';

class AppState {
  final LoadingState viewState;
  final BaseResponse? response;

  const AppState._({
    required this.viewState,
    this.response,
  });

  factory AppState.initial() => const AppState._(
        viewState: LoadingState.idle,
      );

  AppState copyWith({
    BaseResponse? response,
    LoadingState? viewState,
  }) {
    return AppState._(
      response: response ?? this.response,
      viewState: viewState ?? this.viewState,
    );
  }
}
