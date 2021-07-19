class VehicleType {
  VehicleType({
    this.typeId,
    this.capacity,
    this.profile,
  });

  String? typeId;
  List<int>? capacity;
  String? profile;

  factory VehicleType.fromMap(Map<String, dynamic> json) => VehicleType(
        typeId: json["type_id"],
        capacity: List<int>.from(json["capacity"].map((x) => x)),
        profile: json["profile"],
      );

  Map<String, dynamic> toMap() => {
        "type_id": typeId,
        "capacity": List<dynamic>.from(capacity!.map((x) => x)),
        "profile": profile,
      };
}
