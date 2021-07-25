class Location {
  Location({
    this.id,
    this.latitude,
    this.longitude,
    this.availableFromUtc,
    this.availableUntilUtc,
    this.vehiclesAllowed,
    this.vehicleTypesAllowed,
    this.vehicleTypesRefused,
    this.vehicleFeaturesRequired,
  });

  String? id;
  String? latitude;
  String? longitude;
  DateTime? availableFromUtc;
  DateTime? availableUntilUtc;
  List<String>? vehiclesAllowed;
  List<String>? vehicleTypesAllowed;
  List<String>? vehicleTypesRefused;
  List<String>? vehicleFeaturesRequired;

  factory Location.fromMap(Map<String, dynamic> json) => Location(
        id: json["id"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        availableFromUtc: DateTime.parse(json["available_from_utc"]),
        availableUntilUtc: DateTime.parse(json["available_until_utc"]),
        vehiclesAllowed:
            List<String>.from(json["vehicles_allowed"].map((x) => x)),
        vehicleTypesAllowed:
            List<String>.from(json["vehicle_types_allowed"].map((x) => x)),
        vehicleTypesRefused:
            List<String>.from(json["vehicle_types_refused"].map((x) => x)),
        vehicleFeaturesRequired:
            List<String>.from(json["vehicle_features_required"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "latitude": latitude,
        "longitude": longitude,
        "available_from_utc": availableFromUtc!.toIso8601String(),
        "available_until_utc": availableUntilUtc!.toIso8601String(),
        "vehicles_allowed": List<dynamic>.from(vehiclesAllowed!.map((x) => x)),
        "vehicle_types_allowed":
            List<dynamic>.from(vehicleTypesAllowed!.map((x) => x)),
        "vehicle_types_refused":
            List<dynamic>.from(vehicleTypesRefused!.map((x) => x)),
        "vehicle_features_required":
            List<dynamic>.from(vehicleFeaturesRequired!.map((x) => x)),
      };
}
