import 'dart:convert';

import 'package:bbv_learning_flutter/models/authen_model.dart';
import 'package:http/http.dart';

import '../models/transaction_item.dart';

class APISerivce {
  final String webApiKey = 'AIzaSyAWInX5SyDjpS8llnkdWzMAayHE43yZbDs';
  final String firebaseAuthenUrl = 'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=';
  final String dbUrl = 'https://firestore.googleapis.com/v1/projects/bbv-learning-flutter/databases/(default)/documents/transactions';

  final int SUCCESS = 200;

  String idToken = '';

  Future<AuthenModel?> loginToFirebase() async {
    print('>>>>>>> loginToFirebase <<<<<<<');
    Map<String, String> headers = {"Content-type": "application/json"};
    String body = '{"returnSecureToken": true}';
    Response response = await post(Uri.parse('$firebaseAuthenUrl$webApiKey'), headers: headers, body: body);
    int statusCode = response.statusCode;

    if (statusCode == SUCCESS) {
      String body = response.body;
      AuthenModel authenModel = AuthenModel.fromJson(json.decode(response.body));
      idToken = authenModel.idToken;
      print('>> body: $body');
      return authenModel;
    } else {
      print('>>>>>>> request error: ${response.body.toString()}');
      return null;
    }
  }

  postTransaction(TransactionItem transactionItem) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $idToken',
    };
    String bodyRequest = jsonEncode(transactionItem.toFirestore());
    Response response = await post(Uri.parse(dbUrl), headers: headers, body: bodyRequest);
    int statusCode = response.statusCode;
    if (statusCode == SUCCESS) {
      String body = response.body;
      print('>>>> Sync Transaction success');
    } else {
      print('>>>>>>> request error: ${response.body.toString()}');
    }
  }

  Future<List<TransactionItem>> getTransactions() async {
    Response res = await get(Uri.parse(dbUrl));
    if (res.statusCode == SUCCESS) {
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
}