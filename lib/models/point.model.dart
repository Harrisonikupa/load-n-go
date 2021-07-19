class Point {
  Point({
    this.coordinates,
    this.type,
  });

  List<List<double>>? coordinates;
  String? type;

  factory Point.fromMap(Map<String, dynamic> json) => Point(
        coordinates: List<List<double>>.from(json["coordinates"]
            .map((x) => List<double>.from(x.map((x) => x.toDouble())))),
        type: json["type"],
      );

  Map<String, dynamic> toMap() => {
        "coordinates": List<dynamic>.from(
            coordinates!.map((x) => List<dynamic>.from(x.map((x) => x)))),
        "type": type,
      };
}
