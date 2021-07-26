import 'package:loadngo/models/goloop/single-models/container.model.dart';
import 'package:loadngo/models/goloop/single-models/visitable-locations-for-features.model.dart';

class Vehicle {
  Vehicle({
    this.id,
    this.type,
    this.locationStartId,
    this.locationEndId,
    this.availableFromUtc,
    this.availableUntilUtc,
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
  String? availableUntilUtc;
  List<Container>? containers;
  List<String>? fixedFeatures;
  VisitableLocationsForFeature? visitableLocationsForFeature;
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
        containers: List<Container>.from(
            json["containers"].map((x) => Container.fromMap(x))),
        fixedFeatures: List<String>.from(json["fixed_features"].map((x) => x)),
        visitableLocationsForFeature: VisitableLocationsForFeature.fromMap(
            json["visitable_locations_for_feature"]),
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
        "containers": List<dynamic>.from(containers!.map((x) => x.toMap())),
        "fixed_features": List<dynamic>.from(fixedFeatures!.map((x) => x)),
        "visitable_locations_for_feature":
            visitableLocationsForFeature!.toMap(),
        "price_per_delivery_cents": pricePerDeliveryCents,
        "price_per_km_cents": pricePerKmCents,
        "price_per_hour_cents": pricePerHourCents,
        "max_distance_metres": maxDistanceMetres,
      };
}
