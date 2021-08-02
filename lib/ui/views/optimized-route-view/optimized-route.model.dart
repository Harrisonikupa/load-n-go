import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:loadngo/app/app.locator.dart';
import 'package:loadngo/app/app.router.dart';
import 'package:loadngo/models/goloop/job/job-details.model.dart';
import 'package:loadngo/models/goloop/job/job-solution.dart';
import 'package:loadngo/models/goloop/job/job-status.model.dart';
import 'package:loadngo/models/goloop/job/manifest.model.dart';
import 'package:loadngo/models/goloop/job/submitted-job.model.dart';
import 'package:loadngo/models/goloop/single-models/capacity-used.model.dart';
import 'package:loadngo/models/goloop/single-models/capacity.model.dart';
import 'package:loadngo/models/goloop/single-models/consignment.model.dart';
import 'package:loadngo/models/goloop/single-models/container.model.dart';
import 'package:loadngo/models/goloop/single-models/job.model.dart';
import 'package:loadngo/models/goloop/single-models/location.model.dart';
import 'package:loadngo/models/goloop/single-models/model-options.model.dart';
import 'package:loadngo/models/goloop/single-models/priority.model.dart';
import 'package:loadngo/models/goloop/single-models/vehicle.model.dart';
import 'package:loadngo/models/order-with-location.model.dart';
import 'package:loadngo/services/Thirdparty/goloop.service.dart';
import 'package:loadngo/services/firebase/firestore.service.dart';
import 'package:loadngo/shared/secrets.dart';
import 'package:loadngo/shared/storage/shared-preferences.storage.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:uuid/uuid.dart';

class OptimizedRouteViewModel extends BaseViewModel {
  final NavigationService navigationService = locator<NavigationService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final DialogService _dialogService = locator<DialogService>();
  final GoloopService _goloopService = locator<GoloopService>();
  void navigateBack() => navigationService.back();
  final formKey = GlobalKey<FormState>();
  var availableFromController = new TextEditingController();
  var availableUntilController = new TextEditingController();
  var maximumCapacityController = new TextEditingController();
  var maximumDistanceController = new TextEditingController();
  List<OrderWithLocation> _orders = [];
  List<OrderWithLocation> get orders => _orders;

  List<OrderWithLocation> _refinedOrders = [];
  List<OrderWithLocation> get refinedOrders => _refinedOrders;

  List<Job> _jobs = [];
  List<Job> get jobs => _jobs;
  SubmittedJob _submittedJob = new SubmittedJob();

  var depotLatitude;
  var depotLongitude;
  var depotLatitude2;
  var depotLongitude2;

  modelIsReady() async {
    setBusy(true);
    listenToJobs();
    await fetchOrders();
    // await getSubmittedJobs();
    var response = await convertDeliveryAddressesToLongAndLat(_orders);
    if (response is List<OrderWithLocation>) {
      _refinedOrders = response;
    }
    setBusy(false);
  }

  Future fetchOrders() async {
    setBusy(true);
    var orderResults = await _firestoreService.getOrdersWithoutListeners();

    if (orderResults is List<OrderWithLocation>) {
      _orders = orderResults;
      notifyListeners();
    } else {
      _dialogService.showDialog(
          title: 'Order update failed', description: orderResults);
    }
    setBusy(false);
  }

  Future convertDeliveryAddressesToLongAndLat(
      List<OrderWithLocation> orders) async {
    List<OrderWithLocation> ordersWithCoordinates = <OrderWithLocation>[];
    orders.forEach((order) async {
      print('delivery code is ${order.deliveryPostalCode}');
      List<Location> locations =
          await locationFromAddress(order.deliveryPostalCode!);
      print('It happened the delivery code ${order.deliveryPostalCode}');

      locations.forEach((location) {
        order.longitude = location.longitude;
        order.latitude = location.latitude;
        ordersWithCoordinates.add(order);
      });
    });
    return Future.delayed(Duration(seconds: 5), () => ordersWithCoordinates);
  }

  createJob() async {
    setBusy(true);
    int clientServiceTime = 10;
    JobDetails job = new JobDetails();
    ModelOptions modelOptions = new ModelOptions();
    List<Consignment> consignments = <Consignment>[];
    List<Locations> locations = <Locations>[];
    List<Vehicle> vehicles = <Vehicle>[];
    List<Priority> priorities = <Priority>[];
    var uuid = Uuid();

    List<Location> depotLocation = await locationFromAddress('486016');

    Future.delayed(
        Duration(seconds: 1),
        () => {
              depotLocation.forEach((location) {
                depotLongitude = location.longitude;
                depotLatitude = location.latitude;
              })
            });

    // Populate model options
    modelOptions.computeTimeMilliseconds = 25000;
    modelOptions.lateHourlyPenaltyCents = 1000;
    modelOptions.workingTimeLimitMinutes = 1020;
    modelOptions.timeWindows = 'soft';
    modelOptions.performBreaks = false;
    modelOptions.nodeSlackTimeMinutes = 10;
    modelOptions.firstSolutionStrategy = null;
    modelOptions.localSearchMetaheuristic = null;

    // Add model option to job object
    job.modelOptions = modelOptions;

    // Add locations
    Locations depotLongLat = new Locations();
    depotLongLat.id = uuid.v4().toString();
    depotLongLat.latitude = depotLatitude.toString();
    depotLongLat.longitude = depotLongitude.toString();
    locations.add(depotLongLat);

    int? lastTimeAdded = 0;
    const increase = 15;
    refinedOrders.asMap().forEach((index, order) {
      Locations location = new Locations();
      location.id = uuid.v4().toString();
      location.latitude = order.latitude.toString();
      location.longitude = order.longitude.toString();
      locations.add(location);
      //-------------------------------------------------------------------//

      Consignment consignment = new Consignment();
      consignment.id = uuid.v4().toString();
      consignment.locationIdFrom = depotLongLat.id;
      consignment.locationIdTo = location.id;
      consignment.priority = 'standard';
      consignment.pickupTimeStartUtc =
          convertDateString('${order.pickupDate}${Secrets.date_suffix}', 0);
      consignment.pickupTimeEndUtc =
          convertDateString('${order.pickupDate}${Secrets.date_suffix}', 720);
      consignment.pickupServiceTimeMinutes = clientServiceTime;
      consignment.pickupTimeWindowConstraint = 'soft';
      consignment.deliverTimeStartUtc = convertDateString(
          '${order.deliveryDate}${Secrets.date_suffix}', lastTimeAdded);
      consignment.deliverTimeEndUtc = convertDateString(
          '${order.deliveryDate}${Secrets.date_suffix}',
          lastTimeAdded! + increase);
      consignment.deliverServiceTimeMinutes = clientServiceTime;
      consignment.deliverTimeWindowConstraint = 'soft';
      CapacitiesUsed capacitiesUsed = new CapacitiesUsed();
      capacitiesUsed.type = 'weight';
      capacitiesUsed.units = 'kg';
      capacitiesUsed.used = order.quantity;
      consignment.capacitiesUsed = [capacitiesUsed];
      consignment.vehicleContainerTypeRequired = 'generic';
      consignments.add(consignment);
      lastTimeAdded = lastTimeAdded! + increase;
    });

    // Vehicle One
    Vehicle vehicle = new Vehicle();
    vehicle.id = uuid.v4().toString();
    vehicle.type = 'General';
    vehicle.locationStartId = depotLongLat.id;
    vehicle.locationEndId = depotLongLat.id;
    vehicle.breakDurationMinutes = 0;
    vehicle.breakTimeWindowStart = convertDateString(
        '${refinedOrders[0].pickupDate}${Secrets.date_suffix}', 730);
    vehicle.breakTimeWindowEnd = convertDateString(
        '${refinedOrders[0].pickupDate}${Secrets.date_suffix}', 730);
    vehicle.availableFromUtc = convertDateString(
        '${refinedOrders[0].pickupDate}${Secrets.date_suffix}', 0);
    vehicle.availableUntilUtc = convertDateString(
      '${refinedOrders[0].pickupDate}${Secrets.date_suffix}',
      1000,
    );
    Containerr container = new Containerr();
    container.type = uuid.v4().toString();
    Capacity capacity = new Capacity();
    capacity.type = uuid.v4().toString();
    capacity.type = 'weight';
    capacity.units = 'kg';
    capacity.maximum = 750;
    container.capacities = [capacity];
    container.type = 'generic';
    vehicle.containers = [container];
    // vehicle.fixedFeatures = [''];
    // VisitableLocationsForFeature property = new VisitableLocationsForFeature();
    // property.property1 = [''];
    // property.property2 = [''];
    // vehicle.visitableLocationsForFeature = property;

    vehicle.pricePerDeliveryCents = 0;
    vehicle.pricePerKmCents = 2000;
    vehicle.pricePerHourCents = 0;
    vehicle.maxDistanceMetres = 100000;
    vehicles.add(vehicle);

    // Vehicle Two
    Vehicle vehicleTwo = new Vehicle();
    vehicleTwo.id = uuid.v4().toString();
    vehicleTwo.type = 'General';
    vehicleTwo.locationStartId = depotLongLat.id;
    vehicleTwo.locationEndId = depotLongLat.id;
    vehicleTwo.breakDurationMinutes = 0;
    vehicleTwo.breakTimeWindowStart = convertDateString(
        '${refinedOrders[0].pickupDate}${Secrets.date_suffix}', 730);
    vehicleTwo.breakTimeWindowEnd = convertDateString(
        '${refinedOrders[0].pickupDate}${Secrets.date_suffix}', 730);
    vehicleTwo.availableFromUtc = convertDateString(
        '${refinedOrders[0].pickupDate}${Secrets.date_suffix}', 0);
    vehicleTwo.availableUntilUtc = convertDateString(
      '${refinedOrders[0].pickupDate}${Secrets.date_suffix}',
      1000,
    );
    Containerr containerTwo = new Containerr();
    containerTwo.type = uuid.v4().toString();
    Capacity capacityTwo = new Capacity();
    capacityTwo.type = uuid.v4().toString();
    capacityTwo.type = 'weight';
    capacityTwo.units = 'kg';
    capacityTwo.maximum = 250;
    containerTwo.capacities = [capacity];
    containerTwo.type = 'generic';
    vehicleTwo.containers = [container];
    // vehicle.fixedFeatures = [''];
    // VisitableLocationsForFeature property = new VisitableLocationsForFeature();
    // property.property1 = [''];
    // property.property2 = [''];
    // vehicle.visitableLocationsForFeature = property;

    vehicleTwo.pricePerDeliveryCents = 0;
    vehicleTwo.pricePerKmCents = 2000;
    vehicleTwo.pricePerHourCents = 0;
    vehicleTwo.maxDistanceMetres = 100000;
    vehicles.add(vehicleTwo);

    // Setting priority
    Priority priority = new Priority();
    priority.id = 'standard';
    priority.penaltyFactor = 10;
    priorities.add(priority);

    job.modelOptions = modelOptions;
    job.consignments = consignments;
    job.locations = locations;
    job.vehicles = vehicles;
    job.priorities = priorities;

    var response = await _goloopService.postJob(job);

    if (response is SubmittedJob) {
      _submittedJob = response;
      Job jobInstance = new Job();
      jobInstance.jobId = _submittedJob.jobId;
      jobInstance.jobString = prettyObject(job.toMap());

      var result = await _firestoreService.addJob(jobInstance);

      if (result is String) {
        await _dialogService.showDialog(
            title: 'Could not create order', description: result);
      } else {
        await _dialogService.showDialog(
          title: 'Job submitted successfully',
          description: 'Your job was submitted successfully',
        );
      }
      // DataStorage.setJob(job);
      // await getSubmittedJobs();
    } else {
      setBusy(false);
      print('Could not do that');
    }
    setBusy(false);
  }

  convertDateString(dateString, minuteToAdd) {
    String date = DateTime.parse(dateString)
        .add(Duration(minutes: minuteToAdd))
        .toIso8601String();
    date = date.substring(0, date.length - 8);
    return '${date}Z';
    // DateFormat formatter = new DateFormatter()
  }

  prettyObject(dynamic object) {
    final prettyString = JsonEncoder.withIndent(" ").convert(object);
    return prettyString;
  }

  getSolution(index) async {
    setBusy(true);
    int? jobId = jobs[index].jobId;
    JobDetails jobDetails = new JobDetails();
    var problemForJobResult = await _goloopService.getProblemForJob(jobId);
    if (problemForJobResult is JobDetails) {
      jobDetails = problemForJobResult;
      await DataStorage.setJob(jobDetails);
    }
    var jobSolutionResult = await _goloopService.getSolutionForJob(jobId);
    if (jobSolutionResult is JobSolution) {
      JobSolution solution = jobSolutionResult;
      var statusResult =
          await _goloopService.getStatusForSolution(jobId, solution.solutionId);
      if (statusResult is JobStatus) {
        if (statusResult.status == 'FOUND') {
          var manifestResult =
              await _goloopService.getJobManifest(jobId, solution.solutionId);
          if (manifestResult is Manifest) {
            await DataStorage.setManifest(manifestResult);
            navigationService.navigateTo(Routes.manifestView);
            // Route us to the map
          } else {
            debugPrint('Manifest not found');
          }
        } else {
          _dialogService.showDialog(
              title: 'In Progress!',
              description:
                  'Your optimization is currently in progress. It\'ll just take a few minutes');
        }
      }
    }

    setBusy(false);
  }

  void listenToJobs() {
    setBusy(true);
    _firestoreService.listenToJobsRealTime().listen((jobsData) {
      List<Job> updatedJobs = jobsData;
      if (jobsData != null && updatedJobs.length > 0) {
        _jobs = updatedJobs;
        notifyListeners();
      }
      setBusy(false);
    });
  }
}
