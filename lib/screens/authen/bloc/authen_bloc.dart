
import 'dart:async';

import 'package:bbv_learning_flutter/services/authen_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'authen_event.dart';
import 'authen_state.dart';

class AuthenBloc extends Bloc<AuthenEvent, AuthenState> {
  final AuthenRepository authenRepo;
  late StreamSubscription<AuthenStatus> _authenStatusSub;

  AuthenBloc(AuthenState initialState, this.authenRepo) : super(initialState) {
    on<LoginEvent>(_login);
    on<SignUpEvent>(_register);

    on<AuthenStatusChanged>(_authenStatusChanged);

    _authenStatusSub = authenRepo.status.listen((status) {
      // (status) {
      //   print('>>>>> authenRepo.status; $status 1111');
      // };
      (status) => add(AuthenStatusChanged(status));
    });
  }

  void _authenStatusChanged(event, emit) async {
    print('>>>>> _authenStatusChanged ${event.status}');
    switch (event.status) {
      case AuthenStatus.unauthenticated:
        emit(const AuthenState.unauthenticated());
        break;
      case AuthenStatus.authenticated:
        emit(const AuthenState.authenticated());
        break;
      default:
        emit(const AuthenState.unknow());
        break;
    }
  }

  FutureOr<void> _register(event, emit) {
    authenRepo.signUpWithEmail(event.email, event.password);
  }

  FutureOr<void> _login(LoginEvent event, Emitter<AuthenState> emit) async {
    authenRepo.loginWithEmail(event.email, event.password);
    // _onAuthenticationStatusChanged(status);
  }

  @override
  Future<void> close() {
    authenRepo.dispose();
    _authenStatusSub.cancel();
    return super.close();
  }
}