// To parse this JSON data, do
//
//     final createJobRequest = createJobRequestFromMap(jsonString);

import 'dart:convert';

import 'package:loadngo/models/goloop/single-models/consignment.model.dart';
import 'package:loadngo/models/goloop/single-models/location.model.dart';
import 'package:loadngo/models/goloop/single-models/model-options.model.dart';
import 'package:loadngo/models/goloop/single-models/priority.model.dart';
import 'package:loadngo/models/goloop/single-models/vehicle.model.dart';

JobDetails jobDetailsFromMap(String str) =>
    JobDetails.fromMap(json.decode(str));

String jobDetailsToMap(JobDetails data) => json.encode(data.toMap());

class JobDetails {
  JobDetails({
    this.modelOptions,
    this.consignments,
    this.locations,
    this.vehicles,
    this.priorities,
  });

  ModelOptions? modelOptions;
  List<Consignment>? consignments;
  List<Location>? locations;
  List<Vehicle>? vehicles;
  List<Priority>? priorities;

  factory JobDetails.fromMap(Map<String, dynamic> json) => JobDetails(
        modelOptions: ModelOptions.fromMap(json["model_options"]),
        consignments: List<Consignment>.from(
            json["consignments"].map((x) => Consignment.fromMap(x))),
        locations: List<Location>.from(
            json["locations"].map((x) => Location.fromMap(x))),
        vehicles:
            List<Vehicle>.from(json["vehicles"].map((x) => Vehicle.fromMap(x))),
        priorities: List<Priority>.from(
            json["priorities"].map((x) => Priority.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "model_options": modelOptions!.toMap(),
        "consignments": List<dynamic>.from(consignments!.map((x) => x.toMap())),
        "locations": List<dynamic>.from(locations!.map((x) => x.toMap())),
        "vehicles": List<dynamic>.from(vehicles!.map((x) => x.toMap())),
        "priorities": List<dynamic>.from(priorities!.map((x) => x.toMap())),
      };
}
