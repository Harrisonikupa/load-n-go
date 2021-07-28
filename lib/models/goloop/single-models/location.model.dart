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
  Null availableFromUtc;
  Null availableUntilUtc;
  Null vehiclesAllowed;
  Null vehicleTypesAllowed;
  Null vehicleTypesRefused;
  Null vehicleFeaturesRequired;

  factory Locations.fromMap(Map<String, dynamic> json) => Locations(
        id: json["id"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        availableFromUtc: json["available_from_utc"],
        availableUntilUtc: json["available_until_utc"],
        vehiclesAllowed: json["vehicles_allowed"],
        vehicleTypesAllowed: json["vehicle_types_allowed"],
        vehicleTypesRefused: json["vehicle_types_refused"],
        vehicleFeaturesRequired: json["vehicle_features_required"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "latitude": latitude,
        "longitude": longitude,
        "available_from_utc": availableFromUtc,
        "available_until_utc": availableUntilUtc,
        "vehicles_allowed": vehiclesAllowed,
        "vehicle_types_allowed": vehicleTypesAllowed,
        "vehicle_types_refused": vehicleTypesRefused,
        "vehicle_features_required": vehicleFeaturesRequired,
      };
}
