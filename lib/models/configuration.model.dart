import 'package:loadngo/models/routing.model.dart';

class Configuration {
  Configuration({
    this.routing,
  });

  RoutingModel? routing;

  factory Configuration.fromMap(Map<String, dynamic> json) => Configuration(
        routing: RoutingModel.fromMap(json["routing"]),
      );

  Map<String, dynamic> toMap() => {
        "routing": routing!.toMap(),
      };
}
