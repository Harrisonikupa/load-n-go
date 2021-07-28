import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:loadngo/app/app.locator.dart';
import 'package:loadngo/models/goloop/access-token/access-token-request.model.dart';
import 'package:loadngo/models/goloop/access-token/access-token-response.dart';
import 'package:loadngo/models/goloop/job/submitted-job.model.dart';
import 'package:loadngo/shared/secrets.dart';
import 'package:loadngo/shared/storage/shared-preferences.storage.dart';
import 'package:stacked_services/stacked_services.dart';

class GoloopService {
  var client = new http.Client();
  DialogService _dialogService = locator<DialogService>();
  final headers = <String, String>{};
  AccessTokenResponse accessToken = DataStorage.getAccessToken();
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
  Future postJob(request) async {
    headers['Content-Type'] = 'application/json';
    headers['Authorization'] = 'Bearer ${accessToken.accessToken}';
    var submittedJobResponse = new SubmittedJob();
    var response = await client.post(
        Uri.parse('${Secrets.goloop_base_url}api/v1/solver/job'),
        body: jsonEncode(request),
        headers: headers);

    var parsed = jsonDecode(response.body);

    if (response.statusCode == 200) {
      print('${response.body} >>>>>>>>>>>>>>>>>>>>>> it passed');
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

  Future<List<SubmittedJob>> listOfJobs() async {
    headers['Content-Type'] = 'application/json';
    headers['Authorization'] = 'Bearer ${accessToken.accessToken}';
    var jobs = <SubmittedJob>[];

    var response = await client.get(
        Uri.parse('${Secrets.goloop_base_url}api/v1/solver/job'),
        headers: headers);
    var parsed = json.decode(response.body);
    for (var job in parsed) {
      jobs.add(SubmittedJob.fromMap(job));
    }

    return jobs;
  }
}
