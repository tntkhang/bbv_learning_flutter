abstract class AuthenEvent {}

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

class LoginAnonymousEvent extends AuthenEvent {}

class LogoutEvent extends AuthenEvent {}