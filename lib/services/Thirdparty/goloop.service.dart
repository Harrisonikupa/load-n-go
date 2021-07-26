import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:loadngo/app/app.locator.dart';
import 'package:loadngo/models/goloop/access-token/access-token-request.model.dart';
import 'package:loadngo/models/goloop/access-token/access-token-response.dart';
import 'package:loadngo/models/goloop/job/job-details.model.dart';
import 'package:loadngo/models/goloop/job/submitted-job.model.dart';
import 'package:loadngo/shared/secrets.dart';
import 'package:loadngo/shared/storage/shared-preferences.storage.dart';
import 'package:stacked_services/stacked_services.dart';

class GoloopService {
  var client = new http.Client();
  DialogService _dialogService = locator<DialogService>();
  final headers = <String, String>{};

  // Get access token to make requests
  Future getAccessToken(AccessTokenRequest request) async {
    AccessTokenResponse responseBody = new AccessTokenResponse();
    var response = await client.post(
        Uri.parse('${Secrets.goloop_base_url}token'),
        body: request.toMap());
    print(response.body);
    var parsed = jsonDecode(response.body);
    if (parsed['access_token'] != null) {
      responseBody.accessToken = parsed['access_token'];
      responseBody.expires = parsed['.expires'];
      responseBody.issued = parsed['.issued'];
      responseBody.tokenType = parsed['token_type'];
      responseBody.userName = parsed['userName'];
    } else {
      _dialogService.showDialog(
        title: 'Error',
        description: '${parsed['error']}',
      );
    }

    return responseBody;
  }

  // Post a new Job
  Future postJob(JobDetails request) async {
    headers['Content-Type'] = 'application/json';
    headers['Authorization'] = 'Bearer ${DataStorage.getAccessToken()}';

    print('Started');
    var submittedJobResponse = new SubmittedJob();
    var response = await client.post(
        Uri.parse('${Secrets.goloop_base_url}api/v1/solver/job'),
        body: jsonEncode(request.toMap()));

    var parsed = jsonDecode(response.body);
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      if (parsed is SubmittedJob) {
        submittedJobResponse = parsed;
      }
    } else {
      print('$parsed >>>>>>>>>>>>>>>>> error');
      _dialogService.showDialog(title: 'Error', description: parsed['Message']);
      throw Exception(parsed);
    }
    return submittedJobResponse;
  }
}
