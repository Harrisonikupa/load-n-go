class VisitableLocationsForFeature {
  VisitableLocationsForFeature({
    this.property1,
    this.property2,
  });

  List<String>? property1;
  List<String>? property2;

  factory VisitableLocationsForFeature.fromMap(Map<String, dynamic> json) =>
      VisitableLocationsForFeature(
        property1: List<String>.from(json["property1"].map((x) => x)),
        property2: List<String>.from(json["property2"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "property1": List<dynamic>.from(property1!.map((x) => x)),
        "property2": List<dynamic>.from(property2!.map((x) => x)),
      };
}
