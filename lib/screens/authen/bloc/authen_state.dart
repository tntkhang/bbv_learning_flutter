
import 'package:bbv_learning_flutter/models/authen_model.dart';
import 'package:equatable/equatable.dart';

import '../../../services/authen_repository.dart';

class AuthenState extends Equatable {
  final AuthenStatus status;

  // final AuthenModel authenModel;

  const AuthenState._({
    this.status = AuthenStatus.unknown,
    // this.authenModel = AuthenModel.empty
  });

  const AuthenState.unknow() : this._(status: AuthenStatus.unknown);

  const AuthenState.authenticated()
      : this._(status: AuthenStatus.authenticated);

  const AuthenState.unauthenticated()
      : this._(status: AuthenStatus.unauthenticated);


  @override
  List<Object?> get props => [status];
}