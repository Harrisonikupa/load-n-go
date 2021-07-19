class Unassigned {
  Unassigned({
    this.services,
    this.shipments,
    this.breaks,
    this.details,
  });

  List<dynamic>? services;
  List<dynamic>? shipments;
  List<dynamic>? breaks;
  List<dynamic>? details;

  factory Unassigned.fromMap(Map<String, dynamic> json) => Unassigned(
        services: List<dynamic>.from(json["services"].map((x) => x)),
        shipments: List<dynamic>.from(json["shipments"].map((x) => x)),
        breaks: List<dynamic>.from(json["breaks"].map((x) => x)),
        details: List<dynamic>.from(json["details"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "services": List<dynamic>.from(services!.map((x) => x)),
        "shipments": List<dynamic>.from(shipments!.map((x) => x)),
        "breaks": List<dynamic>.from(breaks!.map((x) => x)),
        "details": List<dynamic>.from(details!.map((x) => x)),
      };
}
