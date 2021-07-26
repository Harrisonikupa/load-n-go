import 'dart:convert';

import 'package:loadngo/models/goloop/access-token/access-token-response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataStorage {
  static late SharedPreferences _preferences;
  static const keyAccessToken = 'accessToken';
  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setAccessToken(AccessTokenResponse accessTokenResponse) async {
    String? jsonString = jsonEncode(accessTokenResponse.toMap());
    await _preferences.setString(keyAccessToken, jsonString);
  }

  static getAccessToken() {
    String? accessToken = _preferences.getString(keyAccessToken);
    AccessTokenResponse data =
        AccessTokenResponse.fromMap(jsonDecode(accessToken!));

    return data;
  }

  static removeStoredData(String key) => _preferences.remove('$key');

  static bool containsKey(String key) {
    return _preferences.containsKey(key);
  }

  static getAll() {
    return _preferences.getKeys();
  }
}
