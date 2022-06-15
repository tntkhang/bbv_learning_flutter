import 'dart:async';
import 'dart:convert';

import 'package:bbv_learning_flutter/services/api_services.dart';
import 'package:http/http.dart';

import '../models/authen_model.dart';

enum AuthenStatus { unknown, authenticated, unauthenticated }

class AuthenRepository {
  final String webApiKey = 'AIzaSyAWInX5SyDjpS8llnkdWzMAayHE43yZbDs';
  final String firebaseAuthenUrl = 'https://identitytoolkit.googleapis.com/v1/accounts';

  final _controller = StreamController<AuthenStatus>();
  APISerivce apiService;

  AuthenRepository(APISerivce this.apiService);

  Stream<AuthenStatus> get status async* {
    yield AuthenStatus.unauthenticated;
    yield* _controller.stream;
  }

  Future<void> loginWithEmail(String email, String password) async {
    Map<String, String> headers = {"Content-type": "application/json"};
    String body = '{"email": "$email", "password": "$password", "returnSecureToken": true}';
    // yield APIStatus.LOADING;
    Response response = await post(Uri.parse('$firebaseAuthenUrl:signInWithPassword?key=$webApiKey'), headers: headers, body: body);
    int statusCode = response.statusCode;

    print('>>>>> $statusCode');
    if (statusCode == ResponseCode.Success) {
      String body = response.body;
      AuthenModel authenModel = AuthenModel.fromJson(json.decode(body));
      // yield authenModel;
      _controller.add(AuthenStatus.authenticated);
      // return Future.value(AuthenStatus.authenticated);
    } else {
      _controller.add(AuthenStatus.unauthenticated);
      // return Future.value(AuthenStatus.unauthenticated);
    }
  }

  Future<void> signUpWithEmail(String email, String password) async {
    Map<String, String> headers = {"Content-type": "application/json"};
    String body = '{"email": "$email", "password": "$password", "returnSecureToken": true}';
    Response response = await post(Uri.parse('$firebaseAuthenUrl:signUp?key=$webApiKey'), headers: headers, body: body);
    int statusCode = response.statusCode;

    if (statusCode == ResponseCode.Success) {
      String body = response.body;
      AuthenModel authenModel = AuthenModel.fromJson(json.decode(body));
      // yield authenModel;
      _controller.add(AuthenStatus.authenticated);
    } else {
      _controller.add(AuthenStatus.unauthenticated);
      // yield APIStatus.ERROR;
    }
  }

 /* Stream<dynamic> loginWithEmail(String email, String password) async* {
    Map<String, String> headers = {"Content-type": "application/json"};
    String body = '{"email": "$email", "password": "$password", "returnSecureToken": true}';
    yield APIStatus.LOADING;
    Response response = await post(Uri.parse('$firebaseAuthenUrl:signInWithPassword?key=$webApiKey'), headers: headers, body: body);
    int statusCode = response.statusCode;

    if (statusCode == ResponseCode.Success) {
      String body = response.body;
      AuthenModel authenModel = AuthenModel.fromJson(json.decode(body));
      yield authenModel;
      _controller.add(AuthenStatus.authenticated);
    } else {
      yield APIStatus.ERROR;
    }
  }
  Stream<dynamic> signUpWithEmail(String email, String password) async* {
    Map<String, String> headers = {"Content-type": "application/json"};
    String body = '{"email": "$email", "password": "$password", "returnSecureToken": true}';
    yield APIStatus.LOADING;
    Response response = await post(Uri.parse('$firebaseAuthenUrl:signUp?key=$webApiKey'), headers: headers, body: body);
    int statusCode = response.statusCode;

    if (statusCode == ResponseCode.Success) {
      String body = response.body;
      AuthenModel authenModel = AuthenModel.fromJson(json.decode(body));
      yield authenModel;
      _controller.add(AuthenStatus.authenticated);
    } else {
      yield APIStatus.ERROR;
    }
  }*/

  void logOut() {
    _controller.add(AuthenStatus.unauthenticated);
  }

  void dispose() => _controller.close();
}