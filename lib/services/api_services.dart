import 'dart:convert';

import 'package:bbv_learning_flutter/models/authen_model.dart';
import 'package:bbv_learning_flutter/utils/preferences.dart';
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
      AuthenModel authenModel = AuthenModel.fromJson(json.decode(body));
      print('>> body: $body');
      yield authenModel;
    } else {
      print('>>>>>>> request error: ${response.body.toString()}');
      yield APIStatus.ERROR;
    }
  }

  Map<String, String> _getBearerHeader(String idToken) => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $idToken',
  };

  Stream<dynamic> postTransaction(TransactionItem transactionItem) async* {
    String bodyRequest = jsonEncode(transactionItem.toFirestore());

    var idToken = await Preferences().getAuthenToken();
    if (idToken != null) {
      yield APIStatus.LOADING;
      Response response = await post(Uri.parse(dbUrl), headers: _getBearerHeader(idToken), body: bodyRequest);
      int statusCode = response.statusCode;
      if (statusCode == ResponseCode.Success) {
        String body = response.body;
        TransactionItem transactionItem = TransactionItem.fromFireStore(json.decode(body));
        print('>>>> Sync Transaction success');
        yield transactionItem;
      } else {
        print('>>>>>>> request error: ${response.body.toString()}');
        yield APIStatus.ERROR;
      }
    }
  }

  Stream<dynamic> deleteTransaction(TransactionItem transactionItem) async* {
    var idToken = await Preferences().getAuthenToken();
    if (idToken != null) {
      yield APIStatus.LOADING;
      Response response = await delete(Uri.parse("$dbUrl/${transactionItem.firestoreId}"), headers: _getBearerHeader(idToken));
      int statusCode = response.statusCode;
      if (statusCode == ResponseCode.Success) {
        print('>>>> Sync Transaction success');
        yield APIStatus.SUCCESS;
      } else {
        print('>>>>>>> request error: ${response.body.toString()}');
        yield APIStatus.ERROR;
      }
    }
  }

  Stream<List<TransactionItem>> getTransactions() async* {
    var idToken = await Preferences().getAuthenToken();
    if (idToken != null) {
      Response res = await get(Uri.parse(dbUrl), headers: _getBearerHeader(idToken));
      if (res.statusCode == ResponseCode.Success) {
        String body = res.body;

        List<TransactionItem> listTransFromFirestore =
            List<TransactionItem>.from(json.decode(body)['documents'].map((x) =>
                TransactionItem.fromFireStore(x))
            );

        yield listTransFromFirestore;
      } else {
        throw "Unable to retrieve posts.";
      }
    }
  }
}