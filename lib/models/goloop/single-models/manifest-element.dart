import 'package:loadngo/models/goloop/single-models/route.model.dart';

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
  List<Route>? route;

  factory ManifestElement.fromMap(Map<String, dynamic> json) => ManifestElement(
        consignments: json["consignments"],
        distanceTotalMetres: json["distance_total_metres"],
        vehicle: json["vehicle"],
        route: List<Route>.from(json["route"].map((x) => Route.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "consignments": consignments,
        "distance_total_metres": distanceTotalMetres,
        "vehicle": vehicle,
        "route": List<dynamic>.from(route!.map((x) => x.toMap())),
      };
}
