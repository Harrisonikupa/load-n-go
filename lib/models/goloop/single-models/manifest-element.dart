class ManifestElement {
  ManifestElement({
    this.consignments,
    this.distanceTotalMetres,
    this.vehicle,
    this.route,
  });

  dynamic consignments;
  dynamic distanceTotalMetres;
  String? vehicle;
  dynamic route;

  factory ManifestElement.fromMap(Map<String, dynamic> json) => ManifestElement(
        consignments: json["consignments"],
        distanceTotalMetres: json["distance_total_metres"],
        vehicle: json["vehicle"],
        route: json["route"],
      );

  Map<String, dynamic> toMap() => {
        "consignments": consignments,
        "distance_total_metres": distanceTotalMetres,
        "vehicle": vehicle,
        "route": route,
      };
}
