import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
  @override
  List<Object?> get props => [];
}

class LoginInUserEvent extends LoginEvent {
  final String password;
  final String email;

  const LoginInUserEvent({required this.password, required this.email});
}
