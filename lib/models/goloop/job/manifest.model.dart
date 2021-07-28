// To parse this JSON data, do
//
//     final manifest = manifestFromMap(jsonString);

import 'dart:convert';

import 'package:loadngo/models/goloop/single-models/manifest-element.dart';
import 'package:loadngo/models/goloop/single-models/manifest-status.model.dart';

Manifest manifestFromMap(String str) => Manifest.fromMap(json.decode(str));

String manifestToMap(Manifest data) => json.encode(data.toMap());

class Manifest {
  Manifest({
    this.droppedConsignments,
    this.manifest,
    this.status,
  });

  dynamic droppedConsignments;
  List<ManifestElement>? manifest;
  ManifestStatus? status;

  factory Manifest.fromMap(Map<String, dynamic> json) => Manifest(
        droppedConsignments:
            List<String>.from(json["dropped_consignments"].map((x) => x)),
        manifest: List<ManifestElement>.from(
            json["manifest"].map((x) => ManifestElement.fromMap(x))),
        status: ManifestStatus.fromMap(json["status"]),
      );

  Map<String, dynamic> toMap() => {
        "dropped_consignments":
            List<dynamic>.from(droppedConsignments!.map((x) => x)),
        "manifest": List<dynamic>.from(manifest!.map((x) => x.toMap())),
        "status": status!.toMap(),
      };
}
