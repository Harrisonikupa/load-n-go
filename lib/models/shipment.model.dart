import 'package:loadngo/models/delivery.model.dart';

class Shipment {
  Shipment({
    this.id,
    this.name,
    this.priority,
    this.pickup,
    this.delivery,
    this.size,
    this.requiredSkills,
  });

  String? id;
  String? name;
  int? priority;
  Delivery? pickup;
  Delivery? delivery;
  List<int>? size;
  List<String>? requiredSkills;

  factory Shipment.fromMap(Map<String, dynamic> json) => Shipment(
        id: json["id"],
        name: json["name"],
        priority: json["priority"],
        pickup: Delivery.fromMap(json["pickup"]),
        delivery: Delivery.fromMap(json["delivery"]),
        size: List<int>.from(json["size"].map((x) => x)),
        requiredSkills:
            List<String>.from(json["required_skills"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "priority": priority,
        "pickup": pickup!.toMap(),
        "delivery": delivery!.toMap(),
        "size": List<dynamic>.from(size!.map((x) => x)),
        "required_skills": List<dynamic>.from(requiredSkills!.map((x) => x)),
      };
}
