import 'package:bbv_learning_flutter/models/authen_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Preferences {
  static const PREF_KEY_AUTHEN_MODE = "pref_key_authen_model";
  static const PREF_KEY_ID_TOKEN = "pref_key_id_token";

  setAuthenToken(AuthenModel authenModel) async {
    print('>>> jsonAuthem saved: ${authenModel.toJson2().toString()}');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(PREF_KEY_ID_TOKEN, authenModel.idToken);
  }

  clearAuthenToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove(PREF_KEY_ID_TOKEN);
  }

  Future<String?> getAuthenToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var jsonAuthenModel = sharedPreferences.getString(PREF_KEY_ID_TOKEN);

    print('>>> jsonAuthem: $jsonAuthenModel');
    return jsonAuthenModel != null ? jsonAuthenModel : null;
  }
}