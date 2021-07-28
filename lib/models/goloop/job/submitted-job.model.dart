// To parse this JSON data, do
//
//     final createJobResponse = createJobResponseFromMap(jsonString);

import 'dart:convert';

SubmittedJob submittedJobFromMap(String str) =>
    SubmittedJob.fromMap(json.decode(str));

String submittedJobToMap(SubmittedJob data) => json.encode(data.toMap());

class SubmittedJob {
  SubmittedJob({
    this.jobId,
    this.relUri,
  });

  int? jobId;
  String? relUri;

  factory SubmittedJob.fromMap(Map<String, dynamic> json) => SubmittedJob(
        jobId: json["job_id"],
        relUri: json["rel_uri"],
      );

  Map<String, dynamic> toMap() => {
        "job_id": jobId,
        "rel_uri": relUri,
      };
}
