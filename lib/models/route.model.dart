import 'package:loadngo/models/activity.model.dart';
import 'package:loadngo/models/point.model.dart';

class Route {
  Route({
    this.vehicleId,
    this.distance,
    this.transportTime,
    this.completionTime,
    this.waitingTime,
    this.serviceDuration,
    this.preparationTime,
    this.points,
    this.activities,
  });

  String? vehicleId;
  int? distance;
  int? transportTime;
  int? completionTime;
  int? waitingTime;
  int? serviceDuration;
  int? preparationTime;
  List<Point>? points;
  List<Activity>? activities;

  factory Route.fromMap(Map<String, dynamic> json) => Route(
        vehicleId: json["vehicle_id"],
        distance: json["distance"],
        transportTime: json["transport_time"],
        completionTime: json["completion_time"],
        waitingTime: json["waiting_time"],
        serviceDuration: json["service_duration"],
        preparationTime: json["preparation_time"],
        points: List<Point>.from(json["points"].map((x) => Point.fromMap(x))),
        activities: List<Activity>.from(
            json["activities"].map((x) => Activity.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "vehicle_id": vehicleId,
        "distance": distance,
        "transport_time": transportTime,
        "completion_time": completionTime,
        "waiting_time": waitingTime,
        "service_duration": serviceDuration,
        "preparation_time": preparationTime,
        "points": List<dynamic>.from(points!.map((x) => x.toMap())),
        "activities": List<dynamic>.from(activities!.map((x) => x.toMap())),
      };
}
