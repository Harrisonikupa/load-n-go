import 'package:loadngo/models/goloop/single-models/manifest-item.model.dart';

class DriversManifest {
  DriversManifest({this.vehicle, this.manifestItems});

  String? vehicle;
  List<ManifestItem>? manifestItems;

  factory DriversManifest.fromMap(Map<String, dynamic> json) => DriversManifest(
        vehicle: json["vehicle"],
        manifestItems: List<ManifestItem>.from(
            json["manifest_items"].map((x) => ManifestItem.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "vehicle": vehicle,
        "manifest_items":
            List<dynamic>.from(manifestItems!.map((x) => x.toMap())),
      };
}
