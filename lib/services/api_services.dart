import 'dart:convert';

import 'package:bbv_learning_flutter/models/authen_model.dart';
import 'package:http/http.dart';

import '../models/transaction_item.dart';

enum APIStatus{LOADING, SUCCESS, ERROR}

class ResponseCode {
  static const int Success = 200;
  static const int BadRequest = 400;
  static const int NotFound = 404;
}

class APISerivce {
  final String webApiKey = 'AIzaSyAWInX5SyDjpS8llnkdWzMAayHE43yZbDs';
  final String firebaseAuthenUrl = 'https://identitytoolkit.googleapis.com/v1/accounts';
  final String dbUrl = 'https://firestore.googleapis.com/v1/projects/bbv-learning-flutter/databases/(default)/documents/transactions';

  String idToken = '';


  Stream<dynamic> loginAnonymous() async* {
    print('>>>>>>> loginAnonymous <<<<<<<');
    Map<String, String> headers = {"Content-type": "application/json"};
    String body = '{"returnSecureToken": true}';
    yield APIStatus.LOADING;
    Response response = await post(Uri.parse('$firebaseAuthenUrl:signUp?key=$webApiKey'), headers: headers, body: body);
    int statusCode = response.statusCode;

    if (statusCode == ResponseCode.Success) {
      String body = response.body;

      AuthenModel authenModel = AuthenModel.fromJson(json.decode(response.body));
      idToken = authenModel.idToken;
      print('>> body: $body');
      yield authenModel;
    } else {
      print('>>>>>>> request error: ${response.body.toString()}');
      yield APIStatus.ERROR;
    }
  }

  Stream<dynamic> loginWithEmail(String email, String password) async* {
    print('>>>>>>> loginWithEmail <<<<<<<');
    Map<String, String> headers = {"Content-type": "application/json"};
    String body = '{"email": "$email", "password": "$password", "returnSecureToken": true}';
    yield APIStatus.LOADING;
    Response response = await post(Uri.parse('$firebaseAuthenUrl:signInWithPassword?key=$webApiKey'), headers: headers, body: body);
    int statusCode = response.statusCode;

    if (statusCode == ResponseCode.Success) {
      String body = response.body;
      AuthenModel authenModel = AuthenModel.fromJson(json.decode(body));
      idToken = authenModel.idToken;
      print('>> body: $body');
      yield authenModel;
    } else {
      print('>>>>>>> request error: ${response.body.toString()}');
      yield APIStatus.ERROR;
    }
  }
  Stream<dynamic> signUpWithEmail(String email, String password) async* {
    print('>>>>>>> loginWithEmail <<<<<<<');
    Map<String, String> headers = {"Content-type": "application/json"};
    String body = '{"email": "$email", "password": "$password", "returnSecureToken": true}';
    yield APIStatus.LOADING;
    Response response = await post(Uri.parse('$firebaseAuthenUrl:signUp?key=$webApiKey'), headers: headers, body: body);
    int statusCode = response.statusCode;

    if (statusCode == ResponseCode.Success) {
      String body = response.body;
      AuthenModel authenModel = AuthenModel.fromJson(json.decode(response.body));
      idToken = authenModel.idToken;
      print('>> body: $body');
      yield authenModel;
    } else {
      print('>>>>>>> request error: ${response.body.toString()}');
      yield APIStatus.ERROR;
    }
  }

  postTransaction(TransactionItem transactionItem) async {
    String bodyRequest = jsonEncode(transactionItem.toFirestore());
    Response response = await post(Uri.parse(dbUrl), headers: _getAuthenHeader(), body: bodyRequest);
    int statusCode = response.statusCode;
    if (statusCode == ResponseCode.Success) {
      String body = response.body;
      print('>>>> Sync Transaction success');
    } else {
      print('>>>>>>> request error: ${response.body.toString()}');
    }
  }

  deleteTransaction(TransactionItem transactionItem) async {
    String bodyRequest = jsonEncode(transactionItem.toFirestore());
    Response response = await delete(Uri.parse(dbUrl), headers: _getAuthenHeader(), body: bodyRequest);
    int statusCode = response.statusCode;
    if (statusCode == ResponseCode.Success) {
      String body = response.body;
      print('>>>> Sync Transaction success');
    } else {
      print('>>>>>>> request error: ${response.body.toString()}');
    }
  }

  Future<List<TransactionItem>> getTransactions() async {
    Response res = await get(Uri.parse(dbUrl), headers: _getAuthenHeader());
    if (res.statusCode == ResponseCode.Success) {
      List<dynamic> body = jsonDecode(res.body);

      List<TransactionItem> posts = body
          .map(
            (dynamic item) => TransactionItem.fromJson(item),
          )
          .toList();

      return posts;
    } else {
      throw "Unable to retrieve posts.";
    }
  }

  Map<String, String> _getAuthenHeader() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $idToken',
    };
  }
}