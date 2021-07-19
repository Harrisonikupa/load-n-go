import 'package:loadngo/models/route.model.dart';
import 'package:loadngo/models/unassigned.model.dart';

class Solution {
  Solution({
    this.costs,
    this.distance,
    this.time,
    this.transportTime,
    this.completionTime,
    this.maxOperationTime,
    this.waitingTime,
    this.serviceDuration,
    this.preparationTime,
    this.noVehicles,
    this.noUnassigned,
    this.routes,
    this.unassigned,
  });

  int? costs;
  int? distance;
  int? time;
  int? transportTime;
  int? completionTime;
  int? maxOperationTime;
  int? waitingTime;
  int? serviceDuration;
  int? preparationTime;
  int? noVehicles;
  int? noUnassigned;
  List<Route>? routes;
  Unassigned? unassigned;

  factory Solution.fromMap(Map<String, dynamic> json) => Solution(
        costs: json["costs"],
        distance: json["distance"],
        time: json["time"],
        transportTime: json["transport_time"],
        completionTime: json["completion_time"],
        maxOperationTime: json["max_operation_time"],
        waitingTime: json["waiting_time"],
        serviceDuration: json["service_duration"],
        preparationTime: json["preparation_time"],
        noVehicles: json["no_vehicles"],
        noUnassigned: json["no_unassigned"],
        routes: List<Route>.from(json["routes"].map((x) => Route.fromMap(x))),
        unassigned: Unassigned.fromMap(json["unassigned"]),
      );

  Map<String, dynamic> toMap() => {
        "costs": costs,
        "distance": distance,
        "time": time,
        "transport_time": transportTime,
        "completion_time": completionTime,
        "max_operation_time": maxOperationTime,
        "waiting_time": waitingTime,
        "service_duration": serviceDuration,
        "preparation_time": preparationTime,
        "no_vehicles": noVehicles,
        "no_unassigned": noUnassigned,
        "routes": List<dynamic>.from(routes!.map((x) => x.toMap())),
        "unassigned": unassigned!.toMap(),
      };
}
