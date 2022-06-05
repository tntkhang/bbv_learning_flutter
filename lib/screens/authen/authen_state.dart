
import 'package:bbv_learning_flutter/models/authen_model.dart';

enum AState{
  SIGNED_IN,
  LOADING,
  SIGNED_OUT
}
class AuthenState {
  final AState authenState;
  AuthenModel? authenModel;

  AuthenState(this.authenState, [this.authenModel]);
}