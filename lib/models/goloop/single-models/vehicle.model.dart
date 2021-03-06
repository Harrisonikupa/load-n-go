import 'package:loadngo/models/goloop/single-models/container.model.dart';

class Vehicle {
  Vehicle({
    this.id,
    this.type,
    this.locationStartId,
    this.locationEndId,
    this.availableFromUtc,
    this.availableUntilUtc,
    this.breakDurationMinutes,
    this.breakTimeWindowStart,
    this.breakTimeWindowEnd,
    this.containers,
    this.fixedFeatures,
    this.visitableLocationsForFeature,
    this.pricePerDeliveryCents,
    this.pricePerKmCents,
    this.pricePerHourCents,
    this.maxDistanceMetres,
  });

  String? id;
  String? type;
  String? locationStartId;
  String? locationEndId;
  String? availableFromUtc;
  int? breakDurationMinutes;
  String? breakTimeWindowStart;
  String? breakTimeWindowEnd;
  String? availableUntilUtc;
  List<Containerr>? containers;
  Null fixedFeatures;
  Null visitableLocationsForFeature;
  int? pricePerDeliveryCents;
  int? pricePerKmCents;
  int? pricePerHourCents;
  int? maxDistanceMetres;

  factory Vehicle.fromMap(Map<String, dynamic> json) => Vehicle(
        id: json["id"],
        type: json["type"],
        locationStartId: json["location_start_id"],
        locationEndId: json["location_end_id"],
        availableFromUtc: json["available_from_utc"],
        availableUntilUtc: json["available_until_utc"],
        breakDurationMinutes: json["break_duration_minutes"],
        breakTimeWindowStart: json["break_time_window_start"],
        breakTimeWindowEnd: json["break_time_window_end"],
        containers: List<Containerr>.from(
          json["containers"].map(
            (x) => Containerr.fromMap(x),
          ),
        ),
        fixedFeatures: json["fixed_features"],
        visitableLocationsForFeature: json["visitable_locations_for_feature"],
        pricePerDeliveryCents: json["price_per_delivery_cents"],
        pricePerKmCents: json["price_per_km_cents"],
        pricePerHourCents: json["price_per_hour_cents"],
        maxDistanceMetres: json["max_distance_metres"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "type": type,
        "location_start_id": locationStartId,
        "location_end_id": locationEndId,
        "available_from_utc": availableFromUtc,
        "available_until_utc": availableUntilUtc,
        "break_duration_minutes": breakDurationMinutes,
        "break_time_window_start": breakTimeWindowStart,
        "break_time_window_end": breakTimeWindowEnd,
        "containers": List<dynamic>.from(containers!.map((x) => x.toMap())),
        "fixed_features": fixedFeatures,
        "visitable_locations_for_feature": visitableLocationsForFeature,
        "price_per_delivery_cents": pricePerDeliveryCents,
        "price_per_km_cents": pricePerKmCents,
        "price_per_hour_cents": pricePerHourCents,
        "max_distance_metres": maxDistanceMetres,
      };
}
