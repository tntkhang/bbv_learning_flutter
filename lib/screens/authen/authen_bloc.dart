
import 'dart:async';
import 'package:bbv_learning_flutter/models/authen_model.dart';
import 'package:bbv_learning_flutter/utils/preferences.dart';

import '../../services/api_services.dart';
import 'authen_event.dart';
import 'authen_state.dart';

class AuthenBloc {
  final APISerivce _apiSerivce = APISerivce();

  var state = AuthenState(AState.SIGNED_OUT);
  final eventController = StreamController<AuthenEvent>();
  final stateController = StreamController<AuthenState>();

  AuthenBloc() {
    eventController.stream.listen((event) {
      if (event is LoginEvent) {
        _apiSerivce.loginWithEmail(event.email, event.password).listen((status) {
          _handleLoginRes(status);
        });
      } else if (event is SignUpEvent) {
        _apiSerivce.signUpWithEmail(event.email, event.password).listen((status) {
          _handleLoginRes(status);
        });
      } else if (event is LogoutEvent) {
        state = AuthenState(AState.SIGNED_OUT);

        stateController.sink.add(state);
      }
    });
  }

  void _handleLoginRes(dynamic data) {
    if (data == APIStatus.LOADING) {
      state = AuthenState(AState.LOADING);
    } else if (data is AuthenModel){
      Preferences().setAuthenToken(data);
      state = AuthenState(AState.SIGNED_IN);
    } else if (data == APIStatus.ERROR){
      state = AuthenState(AState.SIGNED_OUT);
    } else {
      state = AuthenState(AState.SIGNED_OUT);
    }
    stateController.sink.add(state);
  }

  void dispose() {
    stateController.close();
    eventController.close();
  }
}