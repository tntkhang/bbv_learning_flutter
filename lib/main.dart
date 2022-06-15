import 'package:bbv_learning_flutter/services/api_services.dart';
import 'package:bbv_learning_flutter/services/authen_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app.dart';
import 'app_bloc_observer.dart';

void main() {
  final apiService = APISerivce();
  //
  // runApp(MyApp(
  //   authenRepo: AuthenRepository(apiService),
  // ));

  BlocOverrides.runZoned(
        () => runApp(MyApp(authenRepo: AuthenRepository(apiService))),
    blocObserver: AppBlocObserver(),
  );
}
