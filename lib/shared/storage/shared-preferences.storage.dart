import 'dart:convert';

import 'package:loadngo/models/goloop/access-token/access-token-response.dart';
import 'package:loadngo/models/goloop/job/job-details.model.dart';
import 'package:loadngo/models/goloop/job/manifest.model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataStorage {
  static late SharedPreferences _preferences;
  static const keyAccessToken = 'accessToken';
  static const keyManifest = 'manifest';
  static const keyJob = 'job';
  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setAccessToken(AccessTokenResponse accessTokenResponse) async {
    String? jsonString = jsonEncode(accessTokenResponse.toMap());
    await _preferences.setString(keyAccessToken, jsonString);
  }

  static getAccessToken() {
    String? accessToken = _preferences.getString(keyAccessToken);
    print(accessToken);
    AccessTokenResponse data =
        AccessTokenResponse.fromMap(jsonDecode(accessToken!));

    return data;
  }

  static Future setManifest(Manifest manifest) async {
    String? jsonString = jsonEncode(manifest.toMap());
    await _preferences.setString(keyManifest, jsonString);
  }

  static getManifest() {
    String? manifest = _preferences.getString(keyManifest);
    Manifest data = Manifest.fromMap(jsonDecode(manifest!));
    return data;
  }

  static Future setJob(JobDetails job) async {
    String? jsonString = jsonEncode(job.toMap());
    await _preferences.setString(keyJob, jsonString);
  }

  static getJob() {
    String? job = _preferences.getString(keyJob);
    JobDetails data = JobDetails.fromMap(jsonDecode(job!));
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
