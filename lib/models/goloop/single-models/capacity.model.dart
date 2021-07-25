class Capacity {
  Capacity({
    this.type,
    this.units,
    this.maximum,
  });

  String? type;
  String? units;
  int? maximum;

  factory Capacity.fromMap(Map<String, dynamic> json) => Capacity(
        type: json["type"],
        units: json["units"],
        maximum: json["maximum"],
      );

  Map<String, dynamic> toMap() => {
        "type": type,
        "units": units,
        "maximum": maximum,
      };
}
