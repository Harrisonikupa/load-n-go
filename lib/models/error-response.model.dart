// To parse this JSON data, do
//
//     final errorResponse = errorResponseFromMap(jsonString);

import 'dart:convert';

ErrorResponse errorResponseFromMap(String str) =>
    ErrorResponse.fromMap(json.decode(str));

String errorResponseToMap(ErrorResponse data) => json.encode(data.toMap());

class ErrorResponse {
  ErrorResponse({
    this.message,
    this.hints,
    this.status,
  });

  String? message;
  List<Hint>? hints;
  String? status;

  factory ErrorResponse.fromMap(Map<String, dynamic> json) => ErrorResponse(
        message: json["message"],
        hints: List<Hint>.from(json["hints"].map((x) => Hint.fromMap(x))),
        status: json["status"],
      );

  Map<String, dynamic> toMap() => {
        "message": message,
        "hints": List<dynamic>.from(hints!.map((x) => x.toMap())),
        "status": status,
      };
}

class Hint {
  Hint({
    this.message,
    this.details,
  });

  String? message;
  String? details;

  factory Hint.fromMap(Map<String, dynamic> json) => Hint(
        message: json["message"],
        details: json["details"],
      );

  Map<String, dynamic> toMap() => {
        "message": message,
        "details": details,
      };
}
