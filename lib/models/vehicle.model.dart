import 'package:loadngo/models/address.model.dart';

class Vehicle {
  Vehicle({
    this.vehicleId,
    this.typeId,
    this.startAddress,
    this.earliestStart,
    this.latestEnd,
    this.maxJobs,
    this.skills,
  });

  String? vehicleId;
  String? typeId;
  Address? startAddress;
  int? earliestStart;
  int? latestEnd;
  int? maxJobs;
  List<String>? skills;

  factory Vehicle.fromMap(Map<String, dynamic> json) => Vehicle(
        vehicleId: json["vehicle_id"],
        typeId: json["type_id"],
        startAddress: Address.fromMap(json["start_address"]),
        earliestStart: json["earliest_start"],
        latestEnd: json["latest_end"],
        maxJobs: json["max_jobs"],
        skills: json["skills"] == null
            ? null
            : List<String>.from(json["skills"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "vehicle_id": vehicleId,
        "type_id": typeId,
        "start_address": startAddress!.toMap(),
        "earliest_start": earliestStart,
        "latest_end": latestEnd,
        "max_jobs": maxJobs,
        // "skills":
        // skills == null ? null : List<dynamic>.from(skills!.map((x) => x)),
      };
}
