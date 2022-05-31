
class AuthenModel {
  AuthenModel({
      required String idToken,
      required String email,
      required String refreshToken,
      required String expiresIn,
      required String localId,}){
    _idToken = idToken;
    _email = email;
    _refreshToken = refreshToken;
    _expiresIn = expiresIn;
    _localId = localId;
}

  AuthenModel.fromJson(dynamic json) {
    _idToken = json['idToken'];
    _email = json['email'];
    _refreshToken = json['refreshToken'];
    _expiresIn = json['expiresIn'];
    _localId = json['localId'];
  }
  String _idToken = "";
  String _email = "";
  String _refreshToken = "";
  String _expiresIn = "";
  String _localId = "";
AuthenModel copyWith({required String idToken,
  required String email,
  required String refreshToken,
  required String expiresIn,
  required String localId,
}) => AuthenModel(  idToken: idToken,
  email: email,
  refreshToken: refreshToken,
  expiresIn: expiresIn,
  localId: localId,
);
  String get idToken => _idToken;
  String get email => _email;
  String get refreshToken => _refreshToken;
  String get expiresIn => _expiresIn;
  String get localId => _localId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['idToken'] = _idToken;
    map['email'] = _email;
    map['refreshToken'] = _refreshToken;
    map['expiresIn'] = _expiresIn;
    map['localId'] = _localId;
    return map;
  }

}