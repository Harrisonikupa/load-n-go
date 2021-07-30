import 'dart:convert';

ManifestItem manifestItemFromMap(String str) =>
    ManifestItem.fromMap(json.decode(str));

String manifestItemToMap(ManifestItem data) => json.encode(data.toMap());

class ManifestItem {
  ManifestItem(
      {this.longitude,
      this.latitude,
      this.address,
      this.arrivalTime,
      this.departureTime,
      this.vehicleId});

  double? longitude;
  double? latitude;
  String? address;
  String? arrivalTime;
  String? departureTime;
  String? vehicleId;

  factory ManifestItem.fromMap(Map<String, dynamic> json) => ManifestItem(
        longitude: json["longitude"],
        latitude: json["latitude"],
        address: json["address"],
        arrivalTime: json["arrival_time"],
        departureTime: json["departure_time"],
        vehicleId: json["vehicle"],
      );

  Map<String, dynamic> toMap() => {
        "longitude": longitude,
        "latitude": latitude,
        "address": address,
        "arrival_time": arrivalTime,
        "departure_time": departureTime,
        "vehicle": vehicleId,
      };
}
