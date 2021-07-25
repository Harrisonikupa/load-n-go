import 'dart:convert';

AccessTokenResponse accessTokenResponseFromMap(String str) =>
    AccessTokenResponse.fromMap(json.decode(str));

String accessTokenResponseToMap(AccessTokenResponse data) =>
    json.encode(data.toMap());

class AccessTokenResponse {
  AccessTokenResponse({
    this.accessToken,
    this.tokenType,
    this.expiresIn,
    this.userName,
    this.issued,
    this.expires,
  });

  String? accessToken;
  String? tokenType;
  int? expiresIn;
  String? userName;
  DateTime? issued;
  DateTime? expires;

  factory AccessTokenResponse.fromMap(Map<String, dynamic> json) =>
      AccessTokenResponse(
        accessToken: json["access_token"],
        tokenType: json["token_type"],
        expiresIn: json["expires_in"],
        userName: json["userName"],
        issued: DateTime.parse(json[".issued"]),
        expires: DateTime.parse(json[".expires"]),
      );

  Map<String, dynamic> toMap() => {
        "access_token": accessToken,
        "token_type": tokenType,
        "expires_in": expiresIn,
        "userName": userName,
        ".issued": issued!.toIso8601String(),
        ".expires": expires!.toIso8601String(),
      };
}
