import 'package:loadngo/models/goloop/single-models/capacity-used.model.dart';

class Consignment {
  Consignment({
    this.id,
    this.locationIdFrom,
    this.locationIdTo,
    this.priority,
    this.pickupTimeStartUtc,
    this.pickupTimeEndUtc,
    this.pickupServiceTimeMinutes,
    this.pickupTimeWindowConstraint,
    this.deliverTimeStartUtc,
    this.deliverTimeEndUtc,
    this.deliverServiceTimeMinutes,
    this.deliverTimeWindowConstraint,
    this.vehicleContainerTypeRequired,
    this.capacitiesUsed,
    this.vehicleFixedFeaturesRequired,
    this.vehiclesAllowed,
    this.vehiclesRefused,
  });

  String? id;
  String? locationIdFrom;
  String? locationIdTo;
  String? priority;
  DateTime? pickupTimeStartUtc;
  DateTime? pickupTimeEndUtc;
  int? pickupServiceTimeMinutes;
  String? pickupTimeWindowConstraint;
  DateTime? deliverTimeStartUtc;
  DateTime? deliverTimeEndUtc;
  int? deliverServiceTimeMinutes;
  String? deliverTimeWindowConstraint;
  String? vehicleContainerTypeRequired;
  List<CapacitiesUsed>? capacitiesUsed;
  List<String>? vehicleFixedFeaturesRequired;
  List<String>? vehiclesAllowed;
  List<String>? vehiclesRefused;

  factory Consignment.fromMap(Map<String, dynamic> json) => Consignment(
        id: json["id"],
        locationIdFrom: json["location_id_from"],
        locationIdTo: json["location_id_to"],
        priority: json["priority"],
        pickupTimeStartUtc: DateTime.parse(json["pickup_time_start_utc"]),
        pickupTimeEndUtc: DateTime.parse(json["pickup_time_end_utc"]),
        pickupServiceTimeMinutes: json["pickup_service_time_minutes"],
        pickupTimeWindowConstraint: json["pickup_time_window_constraint"],
        deliverTimeStartUtc: DateTime.parse(json["deliver_time_start_utc"]),
        deliverTimeEndUtc: DateTime.parse(json["deliver_time_end_utc"]),
        deliverServiceTimeMinutes: json["deliver_service_time_minutes"],
        deliverTimeWindowConstraint: json["deliver_time_window_constraint"],
        vehicleContainerTypeRequired: json["vehicle_container_type_required"],
        capacitiesUsed: List<CapacitiesUsed>.from(
            json["capacities_used"].map((x) => CapacitiesUsed.fromMap(x))),
        vehicleFixedFeaturesRequired: List<String>.from(
            json["vehicle_fixed_features_required"].map((x) => x)),
        vehiclesAllowed:
            List<String>.from(json["vehicles_allowed"].map((x) => x)),
        vehiclesRefused:
            List<String>.from(json["vehicles_refused"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "location_id_from": locationIdFrom,
        "location_id_to": locationIdTo,
        "priority": priority,
        "pickup_time_start_utc": pickupTimeStartUtc!.toIso8601String(),
        "pickup_time_end_utc": pickupTimeEndUtc!.toIso8601String(),
        "pickup_service_time_minutes": pickupServiceTimeMinutes,
        "pickup_time_window_constraint": pickupTimeWindowConstraint,
        "deliver_time_start_utc": deliverTimeStartUtc!.toIso8601String(),
        "deliver_time_end_utc": deliverTimeEndUtc!.toIso8601String(),
        "deliver_service_time_minutes": deliverServiceTimeMinutes,
        "deliver_time_window_constraint": deliverTimeWindowConstraint,
        "vehicle_container_type_required": vehicleContainerTypeRequired,
        "capacities_used":
            List<dynamic>.from(capacitiesUsed!.map((x) => x.toMap())),
        "vehicle_fixed_features_required":
            List<dynamic>.from(vehicleFixedFeaturesRequired!.map((x) => x)),
        "vehicles_allowed": List<dynamic>.from(vehiclesAllowed!.map((x) => x)),
        "vehicles_refused": List<dynamic>.from(vehiclesRefused!.map((x) => x)),
      };
}
