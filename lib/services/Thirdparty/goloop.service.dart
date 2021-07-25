import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:loadngo/app/app.locator.dart';
import 'package:loadngo/models/goloop/access-token/access-token-request.model.dart';
import 'package:loadngo/models/goloop/access-token/access-token-response.dart';
import 'package:loadngo/shared/secrets.dart';
import 'package:stacked_services/stacked_services.dart';

class GoloopService {
  var client = new http.Client();
  DialogService _dialogService = locator<DialogService>();
  final headers = <String, String>{};

  // Get access token to make requests
  Future getAccessToken(AccessTokenRequest request) async {
    var response = await client
        .post(Uri.parse('${Secrets.goloop_base_url}token'), body: request);

    var parsed = jsonDecode(response.body);
    if (parsed is AccessTokenResponse) {
      print(parsed.toMap());
      return response;
    } else {
      _dialogService.showDialog(
        title: 'Error',
        description: 'There\'s an error with your token',
      );
    }
  }
}
