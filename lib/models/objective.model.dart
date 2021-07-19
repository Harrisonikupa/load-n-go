class Objective {
  Objective({
    this.type,
    this.value,
  });

  String? type;
  String? value;

  factory Objective.fromMap(Map<String, dynamic> json) => Objective(
        type: json["type"],
        value: json["value"],
      );

  Map<String, dynamic> toMap() => {
        "type": type,
        "value": value,
      };
}
