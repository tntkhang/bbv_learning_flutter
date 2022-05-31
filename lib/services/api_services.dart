import 'dart:convert';

import 'package:bbv_learning_flutter/models/authen_model.dart';
import 'package:http/http.dart';

import '../models/transaction_item.dart';

class APISerivce {

  final webApiKey = 'AIzaSyAWInX5SyDjpS8llnkdWzMAayHE43yZbDs';

  String idToken = '';

  Future<AuthenModel?> loginToFirebase() async {
    print('>>>>>>> loginToFirebase <<<<<<<');
    String url = 'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$webApiKey';
    Map<String, String> headers = {"Content-type": "application/json"};
    String body = '{"returnSecureToken": true}';
    Response response = await post(Uri.parse(url), headers: headers, body: body);
    int statusCode = response.statusCode;

    if (statusCode == 200) {
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
    String url = 'https://firestore.googleapis.com/v1/projects/bbv-learning-flutter/databases/(default)/documents/transactions';
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $idToken',
    };
    String bodyRequest = jsonEncode(transactionItem.toFirestore());
    Response response = await post(Uri.parse(url), headers: headers, body: bodyRequest);
    int statusCode = response.statusCode;
    String body = response.body;

    if (statusCode == 200) {
      String body = response.body;
      AuthenModel authenModel = AuthenModel.fromJson(json.decode(response.body));
      idToken = authenModel.idToken;
    } else {
      print('>>>>>>> request error: ${response.body.toString()}');
    }
  }

  Future<List<TransactionItem>> getTransactions() async {
    String url = 'https://firestore.googleapis.com/v1/projects/bbv-learning-flutter/databases/(default)/documents/transactions';

    Response res = await get(Uri.parse(url));
    if (res.statusCode == 200) {
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