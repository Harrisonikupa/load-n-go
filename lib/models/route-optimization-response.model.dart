// To parse this JSON data, do
//
//     final routeOptimizationResponse = routeOptimizationResponseFromMap(jsonString);

import 'dart:convert';

import 'package:loadngo/models/solution.model.dart';

RouteOptimizationResponse routeOptimizationResponseFromMap(String str) =>
    RouteOptimizationResponse.fromMap(json.decode(str));

String routeOptimizationResponseToMap(RouteOptimizationResponse data) =>
    json.encode(data.toMap());

class RouteOptimizationResponse {
  RouteOptimizationResponse({
    this.copyrights,
    this.jobId,
    this.status,
    this.waitingTimeInQueue,
    this.processingTime,
    this.solution,
  });

  List<String>? copyrights;
  String? jobId;
  String? status;
  int? waitingTimeInQueue;
  int? processingTime;
  Solution? solution;

  factory RouteOptimizationResponse.fromMap(Map<String, dynamic> json) =>
      RouteOptimizationResponse(
        copyrights: List<String>.from(json["copyrights"].map((x) => x)),
        jobId: json["job_id"],
        status: json["status"],
        waitingTimeInQueue: json["waiting_time_in_queue"],
        processingTime: json["processing_time"],
        solution: Solution.fromMap(json["solution"]),
      );

  Map<String, dynamic> toMap() => {
        "copyrights": List<dynamic>.from(copyrights!.map((x) => x)),
        "job_id": jobId,
        "status": status,
        "waiting_time_in_queue": waitingTimeInQueue,
        "processing_time": processingTime,
        "solution": solution!.toMap(),
      };
}
