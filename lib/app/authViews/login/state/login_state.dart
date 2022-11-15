// import 'package:equatable/equatable.dart';
// import 'package:health/core/model/base_response.dart';
// import 'package:health/utils/constants/enum.dart';

// class LoginState extends Equatable {
//   final LoadingState viewState;
//   final BaseResponse? response;

//   const LoginState._({
//     required this.viewState,
//     this.response,
//   });

//   factory LoginState.initial() => const LoginState._(
//         viewState: LoadingState.idle,
//       );

//   final int pageSize = 20;

//   LoginState copyWith({
//     BaseResponse? response,
//     LoadingState? viewState,
//   }) {
//     return LoginState._(
//       response: response ?? this.response,
//       viewState: viewState ?? this.viewState,
//     );
//   }

//   @override
//   List<Object?> get props => throw UnimplementedError();
// }

// class LoginInitial extends LoginState {
//   @override
//   List<Object> get props => [];
// }

// class LoginLoadingState extends LoginState {
//   @override
//   List<Object> get props => [];
// }

// class LoginSuccessfulState extends LoginState {
//   @override
//   List<Object> get props => [];
// }

// class LoginFailedState extends LoginState {
//   @override
//   List<Object> get props => [];
// }
