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
  String? pickupTimeStartUtc;
  String? pickupTimeEndUtc;
  int? pickupServiceTimeMinutes;
  String? pickupTimeWindowConstraint;
  String? deliverTimeStartUtc;
  String? deliverTimeEndUtc;
  int? deliverServiceTimeMinutes;
  String? deliverTimeWindowConstraint;
  String? vehicleContainerTypeRequired;
  List<CapacitiesUsed>? capacitiesUsed;
  Null vehicleFixedFeaturesRequired;
  Null vehiclesAllowed;
  Null vehiclesRefused;

  // List<String> vehicleFixedFeaturesRequired;
  // List<String>? vehiclesAllowed;
  // List<String>? vehiclesRefused;
  factory Consignment.fromMap(Map<String, dynamic> json) => Consignment(
        id: json["id"],
        locationIdFrom: json["location_id_from"],
        locationIdTo: json["location_id_to"],
        priority: json["priority"],
        pickupTimeStartUtc: json["pickup_time_start_utc"],
        pickupTimeEndUtc: json["pickup_time_end_utc"],
        pickupServiceTimeMinutes: json["pickup_service_time_minutes"],
        pickupTimeWindowConstraint: json["pickup_time_window_constraint"],
        deliverTimeStartUtc: json["deliver_time_start_utc"],
        deliverTimeEndUtc: json["deliver_time_end_utc"],
        deliverServiceTimeMinutes: json["deliver_service_time_minutes"],
        deliverTimeWindowConstraint: json["deliver_time_window_constraint"],
        vehicleContainerTypeRequired: json["vehicle_container_type_required"],
        capacitiesUsed: List<CapacitiesUsed>.from(
            json["capacities_used"].map((x) => CapacitiesUsed.fromMap(x))),
        vehicleFixedFeaturesRequired: json["vehicle_fixed_features_required"],
        vehiclesAllowed: json["vehicles_allowed"],
        vehiclesRefused: json["vehicles_refused"],
        // vehicleFixedFeaturesRequired: List<String>.from(
        //     json["vehicle_fixed_features_required"].map((x) => x)),
        // vehiclesAllowed:
        // List<String>.from(json["vehicles_allowed"].map((x) => x)),
        // vehiclesRefused:
        // List<String>.from(json["vehicles_refused"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "location_id_from": locationIdFrom,
        "location_id_to": locationIdTo,
        "priority": priority,
        "pickup_time_start_utc": pickupTimeStartUtc,
        "pickup_time_end_utc": pickupTimeEndUtc,
        "pickup_service_time_minutes": pickupServiceTimeMinutes,
        "pickup_time_window_constraint": pickupTimeWindowConstraint,
        "deliver_time_start_utc": deliverTimeStartUtc,
        "deliver_time_end_utc": deliverTimeEndUtc,
        "deliver_service_time_minutes": deliverServiceTimeMinutes,
        "deliver_time_window_constraint": deliverTimeWindowConstraint,
        "vehicle_container_type_required": vehicleContainerTypeRequired,
        "capacities_used":
            List<dynamic>.from(capacitiesUsed!.map((x) => x.toMap())),
        "vehicle_fixed_features_required": vehicleFixedFeaturesRequired,
        "vehicles_allowed": vehiclesAllowed,
        "vehicles_refused": vehiclesRefused,
      };
}
