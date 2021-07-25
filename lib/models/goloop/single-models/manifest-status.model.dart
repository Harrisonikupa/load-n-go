class ManifestStatus {
  ManifestStatus({
    this.code,
  });

  int? code;

  factory ManifestStatus.fromMap(Map<String, dynamic> json) => ManifestStatus(
        code: json["code"],
      );

  Map<String, dynamic> toMap() => {
        "code": code,
      };
}
