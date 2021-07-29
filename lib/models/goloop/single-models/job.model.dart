class Job {
  Job({
    this.jobId,
    this.jobString,
    this.documentId,
  });

  int? jobId;
  String? jobString;
  String? documentId;

  factory Job.fromMap(Map<String, dynamic> json, String documentId) => Job(
      jobId: json["jobId"],
      jobString: json["jobString"],
      documentId: documentId);

  Map<String, dynamic> toMap() => {
        "jobId": jobId,
        "jobString": jobString,
      };
}
