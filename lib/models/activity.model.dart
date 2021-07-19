import 'package:loadngo/models/address.model.dart';

class Activity {
  Activity({
    this.type,
    this.locationId,
    this.address,
    this.endTime,
    this.endDateTime,
    this.distance,
    this.drivingTime,
    this.preparationTime,
    this.waitingTime,
    this.loadAfter,
    this.id,
    this.arrTime,
    this.arrDateTime,
    this.loadBefore,
  });

  String? type;
  String? locationId;
  Address? address;
  int? endTime;
  dynamic endDateTime;
  int? distance;
  int? drivingTime;
  int? preparationTime;
  int? waitingTime;
  List<int>? loadAfter;
  String? id;
  int? arrTime;
  dynamic arrDateTime;
  List<int>? loadBefore;

  factory Activity.fromMap(Map<String, dynamic> json) => Activity(
        type: json["type"],
        locationId: json["location_id"],
        address: Address.fromMap(json["address"]),
        endTime: json["end_time"] == null ? null : json["end_time"],
        endDateTime: json["end_date_time"],
        distance: json["distance"],
        drivingTime: json["driving_time"],
        preparationTime: json["preparation_time"],
        waitingTime: json["waiting_time"],
        loadAfter: json["load_after"] == null
            ? null
            : List<int>.from(json["load_after"].map((x) => x)),
        id: json["id"] == null ? null : json["id"],
        arrTime: json["arr_time"] == null ? null : json["arr_time"],
        arrDateTime: json["arr_date_time"],
        loadBefore: json["load_before"] == null
            ? null
            : List<int>.from(json["load_before"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "type": type,
        "location_id": locationId,
        "address": address!.toMap(),
        "end_time": endTime == null ? null : endTime,
        "end_date_time": endDateTime,
        "distance": distance,
        "driving_time": drivingTime,
        "preparation_time": preparationTime,
        "waiting_time": waitingTime,
        "load_after": loadAfter == null
            ? null
            : List<dynamic>.from(loadAfter!.map((x) => x)),
        "id": id == null ? null : id,
        "arr_time": arrTime == null ? null : arrTime,
        "arr_date_time": arrDateTime,
        "load_before": loadBefore == null
            ? null
            : List<dynamic>.from(loadBefore!.map((x) => x)),
      };
}
