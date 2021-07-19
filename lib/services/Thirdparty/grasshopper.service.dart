import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:loadngo/app/app.locator.dart';
import 'package:loadngo/models/error-response.model.dart';
import 'package:loadngo/models/route-optimization-request.model.dart';
import 'package:loadngo/models/route-optimization-response.model.dart';
import 'package:loadngo/shared/secrets.dart';
import 'package:stacked_services/stacked_services.dart';

class GrasshopperService {
  var client = new http.Client();
  DialogService _dialogService = locator<DialogService>();
  final headers = <String, String>{};

  Future solveVehicleRoutingProblem(RouteOptimizationRequest request) async {
    headers['Content-Type'] = 'application/json';
    var routeOptimizationResponse = new RouteOptimizationResponse();
    try {
      var response = await client.post(
        Uri.parse('${Secrets.base_url}vrp?key=${Secrets.GRASSHOPPER_API_KEY}'),
        body: jsonEncode(request.toMap()),
        headers: headers,
      );

      var parsed = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print(parsed);
        routeOptimizationResponse = RouteOptimizationResponse.fromMap(parsed);
        print(' >>>>>>>>>>>>>>>>>>>>>>>>> successs');
      } else {
        print(' >>>>>>>>>>>>>>>>>>>>>>>>> failed');

        _dialogService.showDialog(
            title: 'Error',
            description:
                ErrorResponse.fromMap(json.decode(response.body)).status);
        throw Exception(ErrorResponse.fromMap(json.decode(response.body)));
      }
    } catch (e) {
      print(e.toString());
      return e.toString();
    }

    return routeOptimizationResponse;
  }
}
