import 'package:bbv_learning_flutter/services/authen_repository.dart';
import 'package:equatable/equatable.dart';

abstract class AuthenEvent extends Equatable {
  const AuthenEvent();

  @override
  List<Object?> get props => [];
}

class AuthenStatusChanged extends AuthenEvent {
  final AuthenStatus status;

  const AuthenStatusChanged(this.status);

  @override
  List<Object?> get props => [status];
}

class LoginEvent extends AuthenEvent {
  final String email;
  final String password;

  LoginEvent(this.email, this.password);
}
class SignUpEvent extends AuthenEvent {
  final String email;
  final String password;

  SignUpEvent(this.email, this.password);
}

class LogoutEvent extends AuthenEvent {}
