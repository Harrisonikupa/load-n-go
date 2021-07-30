import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:loadngo/app/app.locator.dart';
import 'package:loadngo/models/goloop/access-token/access-token-request.model.dart';
import 'package:loadngo/models/goloop/access-token/access-token-response.dart';
import 'package:loadngo/models/goloop/job/job-details.model.dart';
import 'package:loadngo/models/goloop/job/job-solution.dart';
import 'package:loadngo/models/goloop/job/job-status.model.dart';
import 'package:loadngo/models/goloop/job/manifest.model.dart';
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
  Future postJob(JobDetails request) async {
    headers['Content-Type'] = 'application/json';
    headers['Authorization'] = 'Bearer ${accessToken.accessToken}';
    SubmittedJob submittedJobResponse = new SubmittedJob();
    var response = await client.post(
        Uri.parse('${Secrets.goloop_base_url}api/v1/solver/job'),
        body: jsonEncode(request.toMap()),
        headers: headers);

    var parsed = json.decode(response.body);

    if (response.statusCode == 200) {
      submittedJobResponse = SubmittedJob.fromMap(parsed);
    } else {
      _dialogService.showDialog(title: 'Error', description: parsed['Message']);
      return '';
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

  Future getProblemForJob(jobId) async {
    headers['Content-Type'] = 'application/json';
    headers['Authorization'] = 'Bearer ${accessToken.accessToken}';
    dynamic problemForJob;

    var response = await client.get(
        Uri.parse('${Secrets.goloop_base_url}api/v1/solver/job/$jobId'),
        headers: headers);
    var parsed = json.decode(response.body);

    if (response.statusCode == 200) {
      problemForJob = JobDetails.fromMap(parsed);
    } else {
      print('Error >>>>>>>>>>>>>');
    }

    return problemForJob;
  }

  Future getSolutionForJob(jobId) async {
    headers['Content-Type'] = 'application/json';
    headers['Authorization'] = 'Bearer ${accessToken.accessToken}';
    dynamic solutionForJob;

    var response = await client.get(
        Uri.parse(
            '${Secrets.goloop_base_url}api/v1/solver/job/$jobId/solution'),
        headers: headers);
    var parsed = json.decode(response.body);

    if (response.statusCode == 200) {
      print(parsed);
      if (parsed.length > 0) {
        solutionForJob = JobSolution.fromMap(parsed[0]);
      } else {
        print('Error >>>>>>>>>>>>>');
        return;
      }
    } else {
      print('Error >>>>>>>>>>>>>');
    }

    return solutionForJob;
  }

  Future getStatusForSolution(jobId, solutionId) async {
    headers['Content-Type'] = 'application/json';
    headers['Authorization'] = 'Bearer ${accessToken.accessToken}';
    dynamic status;

    var response = await client.get(
        Uri.parse(
            '${Secrets.goloop_base_url}api/v1/solver/job/$jobId/solution/$solutionId/status'),
        headers: headers);
    var parsed = json.decode(response.body);

    if (response.statusCode == 200) {
      status = JobStatus.fromMap(parsed);
    } else {
      print('Error >>>>>>>>>>>>>');
    }

    return status;
  }

  Future getJobManifest(jobId, solutionId) async {
    headers['Content-Type'] = 'application/json';
    headers['Authorization'] = 'Bearer ${accessToken.accessToken}';
    dynamic manifest;

    var response = await client.get(
        Uri.parse(
            '${Secrets.goloop_base_url}api/v1/solver/job/$jobId/solution/$solutionId/result'),
        headers: headers);
    var parsed = json.decode(response.body);

    if (response.statusCode == 200) {
      print('Manifest result >>>>>>>>>>> ${prettyObject(parsed)}');
      manifest = Manifest.fromMap(parsed);
    } else {
      print('Error >>>>>>>>>>>>>');
    }

    return manifest;
  }
}

prettyObject(dynamic object) {
  final prettyString = JsonEncoder.withIndent(" ").convert(object);
  return prettyString;
}
