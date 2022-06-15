
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
    on<SignUpEvent>(
        (event, emit) {
          authenRepo.signUpWithEmail(event.email, event.password);
        }
    );

    _authenStatusSub = authenRepo.status.listen((status) {
      (status) => _onAuthenticationStatusChanged(status);
    });
  }

  void login() {

  }

  void _onAuthenticationStatusChanged(AuthenStatus status) async {
    switch (status) {
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

  void dispose() {
    authenRepo.dispose();
    _authenStatusSub.cancel();
  }

  FutureOr<void> _login(LoginEvent event, Emitter<AuthenState> emit) async {
    await authenRepo.loginWithEmail(event.email, event.password);
    // switch (status) {
    //   case AuthenStatus.unauthenticated:
    //     emit(const AuthenState.unauthenticated());
    //     break;
    //   case AuthenStatus.authenticated:
    //      emit(const AuthenState.authenticated());
    //      break;
    //   default:
    //      emit(const AuthenState.unknow());
    //      break;
    // }
  }
}