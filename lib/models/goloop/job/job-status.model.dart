// To parse this JSON data, do
//
//     final jobStatus = jobStatusFromMap(jsonString);

import 'dart:convert';

JobStatus jobStatusFromMap(String str) => JobStatus.fromMap(json.decode(str));

String jobStatusToMap(JobStatus data) => json.encode(data.toMap());

class JobStatus {
  JobStatus({
    this.status,
  });

  String? status;

  factory JobStatus.fromMap(Map<String, dynamic> json) => JobStatus(
        status: json["status"],
      );

  Map<String, dynamic> toMap() => {
        "status": status,
      };
}
