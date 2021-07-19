class Address {
  Address({
    this.locationId,
    this.lat,
    this.lon,
  });

  String? locationId;
  double? lat;
  double? lon;

  factory Address.fromMap(Map<String, dynamic> json) => Address(
        locationId: json["location_id"],
        lat: json["lat"].toDouble(),
        lon: json["lon"].toDouble(),
      );

  Map<String, dynamic> toMap() => {
        "location_id": locationId,
        "lat": lat,
        "lon": lon,
      };
}
