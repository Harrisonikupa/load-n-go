class Route {
  Route({
    this.arriveAfter,
    this.departBy,
    this.location,
    this.collected,
    this.delivered,
    this.capacity,
  });

  String? arriveAfter;
  String? departBy;
  String? location;
  List<String>? collected;
  List<String>? delivered;
  int? capacity;

  factory Route.fromMap(Map<String, dynamic> json) => Route(
        arriveAfter: json["arrive_after"],
        departBy: json["depart_by"],
        location: json["location"],
        collected: List<String>.from(json["collected"].map((x) => x)),
        delivered: List<String>.from(json["delivered"].map((x) => x)),
        capacity: json["capacity"],
      );

  Map<String, dynamic> toMap() => {
        "arrive_after": arriveAfter,
        "depart_by": departBy,
        "location": location,
        "collected": List<dynamic>.from(collected!.map((x) => x)),
        "delivered": List<dynamic>.from(delivered!.map((x) => x)),
        "capacity": capacity,
      };
}
