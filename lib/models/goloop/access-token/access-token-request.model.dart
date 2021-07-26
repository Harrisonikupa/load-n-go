class AccessTokenRequest {
  AccessTokenRequest({
    this.username,
    this.password,
    this.grantType,
  });

  String? username;
  String? password;
  String? grantType;

  factory AccessTokenRequest.fromMap(Map<String, dynamic> json) =>
      AccessTokenRequest(
        username: json["username"],
        password: json["password"],
        grantType: json["grant_type"],
      );

  Map<String, dynamic> toMap() => {
        "username": username,
        "password": password,
        "grant_type": grantType,
      };
}
