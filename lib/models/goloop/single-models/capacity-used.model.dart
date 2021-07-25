class CapacitiesUsed {
  CapacitiesUsed({
    this.type,
    this.units,
    this.used,
  });

  String? type;
  String? units;
  int? used;

  factory CapacitiesUsed.fromMap(Map<String, dynamic> json) => CapacitiesUsed(
        type: json["type"],
        units: json["units"],
        used: json["used"],
      );

  Map<String, dynamic> toMap() => {
        "type": type,
        "units": units,
        "used": used,
      };
}
