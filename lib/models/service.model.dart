import 'package:loadngo/models/address.model.dart';
import 'package:loadngo/models/time-window.model.dart';

class Service {
  Service({
    this.id,
    this.name,
    this.address,
    this.size,
    this.timeWindows,
  });

  String? id;
  String? name;
  Address? address;
  List<int>? size;
  List<TimeWindow>? timeWindows;

  factory Service.fromMap(Map<String, dynamic> json) => Service(
        id: json["id"],
        name: json["name"],
        address: Address.fromMap(json["address"]),
        size: List<int>.from(json["size"].map((x) => x)),
        timeWindows: json["time_windows"] == null
            ? null
            : List<TimeWindow>.from(
                json["time_windows"].map((x) => TimeWindow.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "address": address!.toMap(),
        "size": List<dynamic>.from(size!.map((x) => x)),
        "time_windows": timeWindows == null
            ? null
            : List<dynamic>.from(timeWindows!.map((x) => x.toMap())),
      };
}
