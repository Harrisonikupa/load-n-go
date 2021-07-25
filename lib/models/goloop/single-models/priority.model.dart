class Priority {
  Priority({
    this.id,
    this.penaltyFactor,
  });

  String? id;
  int? penaltyFactor;

  factory Priority.fromMap(Map<String, dynamic> json) => Priority(
        id: json["id"],
        penaltyFactor: json["penalty_factor"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "penalty_factor": penaltyFactor,
      };
}
