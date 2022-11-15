import 'package:equatable/equatable.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();
  @override
  List<Object?> get props => [];
}

class RegisterUserEvent extends SignUpEvent {
  final String password;
  final String email;
  final String name;
  final String phoneNumber;

  const RegisterUserEvent(
      {required this.password,
      required this.email,
      required this.name,
      required this.phoneNumber});
}
