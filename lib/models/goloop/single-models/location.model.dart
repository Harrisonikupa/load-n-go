class Locations {
  Locations({
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
  String? availableFromUtc;
  String? availableUntilUtc;
  List<String>? vehiclesAllowed;
  List<String>? vehicleTypesAllowed;
  List<String>? vehicleTypesRefused;
  List<String>? vehicleFeaturesRequired;

  factory Locations.fromMap(Map<String, dynamic> json) => Locations(
        id: json["id"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        availableFromUtc: json["available_from_utc"],
        availableUntilUtc: json["available_until_utc"],
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
        "available_from_utc": availableFromUtc,
        "available_until_utc": availableUntilUtc,
        "vehicles_allowed": List<dynamic>.from(vehiclesAllowed!.map((x) => x)),
        "vehicle_types_allowed":
            List<dynamic>.from(vehicleTypesAllowed!.map((x) => x)),
        "vehicle_types_refused":
            List<dynamic>.from(vehicleTypesRefused!.map((x) => x)),
        "vehicle_features_required":
            List<dynamic>.from(vehicleFeaturesRequired!.map((x) => x)),
      };
}
