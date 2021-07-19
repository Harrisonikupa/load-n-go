import 'package:loadngo/models/address.model.dart';

class Delivery {
  Delivery({
    this.address,
  });

  Address? address;

  factory Delivery.fromMap(Map<String, dynamic> json) => Delivery(
        address: Address.fromMap(json["address"]),
      );

  Map<String, dynamic> toMap() => {
        "address": address!.toMap(),
      };
}
