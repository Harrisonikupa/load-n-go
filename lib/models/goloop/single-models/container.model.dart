import 'package:loadngo/models/goloop/single-models/capacity.model.dart';

class Containerr {
  Containerr({
    this.type,
    this.capacities,
  });

  String? type;
  List<Capacity>? capacities;

  factory Containerr.fromMap(Map<String, dynamic> json) => Containerr(
        type: json["type"],
        capacities: List<Capacity>.from(
            json["capacities"].map((x) => Capacity.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "type": type,
        "capacities": List<dynamic>.from(capacities!.map((x) => x.toMap())),
      };
}
