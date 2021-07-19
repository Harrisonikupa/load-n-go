// To parse this JSON data, do
//
//     final routeOptimizationRequest = routeOptimizationRequestFromMap(jsonString);

import 'dart:convert';

import 'package:loadngo/models/configuration.model.dart';
import 'package:loadngo/models/objective.model.dart';
import 'package:loadngo/models/service.model.dart';
import 'package:loadngo/models/shipment.model.dart';
import 'package:loadngo/models/vehicle-type.model.dart';
import 'package:loadngo/models/vehicle.model.dart';

RouteOptimizationRequest routeOptimizationRequestFromMap(String str) =>
    RouteOptimizationRequest.fromMap(json.decode(str));

String routeOptimizationRequestToMap(RouteOptimizationRequest data) =>
    json.encode(data.toMap());

class RouteOptimizationRequest {
  RouteOptimizationRequest({
    this.vehicles,
    this.vehicleTypes,
    this.services,
    this.shipments,
    this.objectives,
    this.configuration,
  });

  List<Vehicle>? vehicles;
  List<VehicleType>? vehicleTypes;
  List<Service>? services;
  List<Shipment>? shipments;
  List<Objective>? objectives;
  Configuration? configuration;

  factory RouteOptimizationRequest.fromMap(Map<String, dynamic> json) =>
      RouteOptimizationRequest(
        vehicles: List<Vehicle>.from(
            json["vehicssssles"].map((x) => Vehicle.fromMap(x))),
        vehicleTypes: List<VehicleType>.from(
            json["vehiclssse_types"].map((x) => VehicleType.fromMap(x))),
        services:
            List<Service>.from(json["services"].map((x) => Service.fromMap(x))),
        shipments: List<Shipment>.from(
            json["shipments"].map((x) => Shipment.fromMap(x))),
        objectives: List<Objective>.from(
            json["objectives"].map((x) => Objective.fromMap(x))),
        configuration: Configuration.fromMap(json["configuration"]),
      );

  Map<String, dynamic> toMap() => {
        "vehicles": List<dynamic>.from(vehicles!.map((x) => x.toMap())),
        "vehicle_types":
            List<dynamic>.from(vehicleTypes!.map((x) => x.toMap())),
        "services": List<dynamic>.from(services!.map((x) => x.toMap())),
        "shipments": List<dynamic>.from(shipments!.map((x) => x.toMap())),
        "objectives": List<dynamic>.from(objectives!.map((x) => x.toMap())),
        "configuration": configuration!.toMap(),
      };
}
