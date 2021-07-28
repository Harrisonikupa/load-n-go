import 'dart:convert';

JobSolution jobSolutionFromMap(String str) =>
    JobSolution.fromMap(json.decode(str));

String jobSolutionToMap(JobSolution data) => json.encode(data.toMap());

class JobSolution {
  JobSolution({
    this.solutionId,
    this.code,
    this.relUri,
  });

  int? solutionId;
  int? code;
  String? relUri;

  factory JobSolution.fromMap(Map<String, dynamic> json) => JobSolution(
        solutionId: json["solution_id"],
        code: json["code"],
        relUri: json["rel_uri"],
      );

  Map<String, dynamic> toMap() => {
        "solution_id": solutionId,
        "code": code,
        "rel_uri": relUri,
      };
}
