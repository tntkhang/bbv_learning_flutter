
import 'dart:convert';

class AuthenModel {
  String idToken = "";
  // String? email = "";
  String refreshToken = "";
  String expiresIn = "";
  String localId = "";

  AuthenModel({
      required this.idToken,
      // required this.email,
      required this.refreshToken,
      required this.expiresIn,
      required this.localId,}){}

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['idToken'] = idToken;
    // map['email'] = email;
    map['refreshToken'] = refreshToken;
    map['expiresIn'] = expiresIn;
    map['localId'] = localId;
    return map;
  }
  Map<String, dynamic> toJson2()  => {
    'idToken': idToken,
    // 'email': email,
    'refreshToken': refreshToken,
    'expiresIn': expiresIn,
    'localId': localId,
  };

  AuthenModel.fromJson(dynamic json) {
    idToken = json['idToken'];
    // email = json['email'] == null ? null : "";
    refreshToken = json['refreshToken'];
    expiresIn = json['expiresIn'] as String;
    localId = json['localId'];
  }

}