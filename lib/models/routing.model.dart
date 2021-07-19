class RoutingModel {
  RoutingModel({
    this.calcPoints,
    this.snapPreventions,
  });

  bool? calcPoints;
  List<String>? snapPreventions;

  factory RoutingModel.fromMap(Map<String, dynamic> json) => RoutingModel(
        calcPoints: json["calc_points"],
        snapPreventions:
            List<String>.from(json["snap_preventions"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "calc_points": calcPoints,
        "snap_preventions": List<dynamic>.from(snapPreventions!.map((x) => x)),
      };
}
