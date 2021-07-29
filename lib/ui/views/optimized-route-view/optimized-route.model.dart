import 'dart:convert';

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

  List<OrderWithLocation> _orders = [];
  List<OrderWithLocation> get orders => _orders;

  List<OrderWithLocation> _refinedOrders = [];
  List<OrderWithLocation> get refinedOrders => _refinedOrders;

  List<Job> _jobs = [];
  List<Job> get jobs => _jobs;
  SubmittedJob _submittedJob = new SubmittedJob();

  var depotLatitude;
  var depotLongitude;
  modelIsReady() async {
    listenToJobs();
    await fetchOrders();
    // await getSubmittedJobs();
    var response = await convertDeliveryAddressesToLongAndLat(orders);
    if (response is List<OrderWithLocation>) {
      _refinedOrders = response;
    }
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
      List<Location> locations =
          await locationFromAddress(order.deliveryPostalCode!);

      locations.forEach((location) {
        order.longitude = location.longitude;
        order.latitude = location.latitude;
        ordersWithCoordinates.add(order);
      });
    });
    return Future.delayed(Duration(seconds: 5), () => ordersWithCoordinates);
  }

  createJob() async {
    int clientServiceTime = 10;
    JobDetails job = new JobDetails();
    ModelOptions modelOptions = new ModelOptions();
    List<Consignment> consignments = <Consignment>[];
    List<Locations> locations = <Locations>[];
    List<Vehicle> vehicles = <Vehicle>[];
    List<Priority> priorities = <Priority>[];
    var uuid = Uuid();

    List<Location> depotLocation =
        await locationFromAddress(refinedOrders[0].pickupPostalCode!);

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
    Container container = new Container();
    container.type = uuid.v4().toString();
    Capacity capacity = new Capacity();
    capacity.type = uuid.v4().toString();
    capacity.type = 'weight';
    capacity.units = 'kg';
    capacity.maximum = 250;
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
    vehicle.maxDistanceMetres = 150000;
    vehicles.add(vehicle);

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
      print('Could not do that');
    }
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

  /*encodeJsonString() {
    dynamic object = {
      "consignments": [
        {
          "capacities_used": [
            {"type": "load", "units": "item", "used": 15}
          ],
          "deliver_service_time_minutes": 5,
          "deliver_time_end_utc": "2020-02-17T18:00Z",
          "deliver_time_start_utc": "2020-02-17T08:30Z",
          "deliver_time_window_constraint": "hard",
          "id": "10728755",
          "priority": "Standard",
          "location_id_from": "loc_a",
          "location_id_to": "loc_b",
          "pickup_service_time_minutes": 5,
          "pickup_time_end_utc": "2020-02-19T17:00Z",
          "pickup_time_start_utc": "2020-02-17T08:30Z",
          "pickup_time_window_constraint": "soft",
          "vehicle_container_type_required": "generic",
          "vehicle_fixed_features_required": null,
          "vehicles_allowed": null,
          "vehicles_refused": null
        },
        {
          "capacities_used": [
            {"type": "load", "units": "item", "used": 26}
          ],
          "deliver_service_time_minutes": 10,
          "deliver_time_end_utc": "2020-02-17T18:00Z",
          "deliver_time_start_utc": "2020-02-17T08:30Z",
          "deliver_time_window_constraint": "hard",
          "id": "10728739",
          "priority": "Standard",
          "location_id_from": "loc_a",
          "location_id_to": "loc_c",
          "pickup_service_time_minutes": 5,
          "pickup_time_end_utc": "2020-02-17T11:00Z",
          "pickup_time_start_utc": "2020-02-17T08:30Z",
          "pickup_time_window_constraint": "soft",
          "vehicle_container_type_required": "generic",
          "vehicle_fixed_features_required": null,
          "vehicles_allowed": null,
          "vehicles_refused": null
        },
        {
          "capacities_used": [
            {"type": "load", "units": "item", "used": 1}
          ],
          "deliver_service_time_minutes": 15,
          "deliver_time_end_utc": "2020-02-17T18:00Z",
          "deliver_time_start_utc": "2020-02-17T08:30Z",
          "deliver_time_window_constraint": "hard",
          "id": "10728632",
          "priority": "Urgent",
          "location_id_from": "loc_a",
          "location_id_to": "loc_d",
          "pickup_service_time_minutes": 5,
          "pickup_time_end_utc": "2020-02-17T18:00Z",
          "pickup_time_start_utc": "2020-02-17T08:30Z",
          "pickup_time_window_constraint": "soft",
          "vehicle_container_type_required": "generic",
          "vehicle_fixed_features_required": null,
          "vehicles_allowed": null,
          "vehicles_refused": null
        }
      ],
      "locations": [
        {
          "available_from_utc": null,
          "available_until_utc": null,
          "id": "loc_a",
          "latitude": "-33.8211673",
          "longitude": "151.1207459",
          "vehicle_features_required": null,
          "vehicle_types_allowed": null,
          "vehicle_types_refused": null,
          "vehicles_allowed": null,
          "vehicles_refused": null,
          "vehicle_features_refused": null
        },
        {
          "available_from_utc": null,
          "available_until_utc": null,
          "id": "loc_b",
          "latitude": "-33.8178616",
          "longitude": "151.1913204",
          "vehicle_features_required": null,
          "vehicle_types_allowed": null,
          "vehicle_types_refused": null,
          "vehicles_allowed": null,
          "vehicles_refused": null,
          "vehicle_features_refused": null
        },
        {
          "available_from_utc": null,
          "available_until_utc": null,
          "id": "loc_c",
          "latitude": "-33.7044223",
          "longitude": "151.21014719999994",
          "vehicle_features_required": null,
          "vehicle_types_allowed": null,
          "vehicle_types_refused": null,
          "vehicles_allowed": null,
          "vehicles_refused": null,
          "vehicle_features_refused": null
        },
        {
          "available_from_utc": null,
          "available_until_utc": null,
          "id": "loc_d",
          "latitude": "-33.810770",
          "longitude": "151.147496",
          "vehicle_features_required": null,
          "vehicle_types_allowed": null,
          "vehicle_types_refused": null,
          "vehicles_allowed": null,
          "vehicles_refused": null,
          "vehicle_features_refused": null
        }
      ],
      "model_options": {
        "compute_time_milliseconds": 12000,
        "late_hourly_penalty_cents": 2000,
        "node_slack_time_minutes": 20,
        "perform_breaks": false,
        "time_windows": "soft",
        "working_time_limit_minutes": 1020,
        "first_solution_strategy": null,
        "local_search_metaheuristic": null
      },
      "vehicles": [
        {
          "available_from_utc": "2020-02-17T08:30Z",
          "available_until_utc": "2020-02-17T18:00Z",
          "break_duration_minutes": 30,
          "break_time_window_end": "2020-02-17T14:00Z",
          "break_time_window_start": "2020-02-17T12:00Z",
          "containers": [
            {
              "capacities": [
                {"maximum": 216, "type": "load", "units": "item"}
              ],
              "type": "generic"
            }
          ],
          "fixed_features": null,
          "id": "DiverA",
          "location_end_id": "loc_a",
          "location_start_id": "loc_a",
          "max_distance_metres": 150000,
          "price_per_delivery_cents": 0,
          "price_per_hour_cents": 0,
          "price_per_km_cents": 3500,
          "type": "Truck",
          "visitable_locations_for_feature": null
        },
        {
          "available_from_utc": "2020-02-17T08:30Z",
          "available_until_utc": "2020-02-17T18:00Z",
          "break_duration_minutes": 30,
          "break_time_window_end": "2020-02-17T14:00Z",
          "break_time_window_start": "2020-02-17T12:00Z",
          "containers": [
            {
              "capacities": [
                {"maximum": 135, "type": "load", "units": "item"}
              ],
              "type": "generic"
            }
          ],
          "fixed_features": null,
          "id": "DiverB",
          "location_end_id": "loc_a",
          "location_start_id": "loc_a",
          "max_distance_metres": 150000,
          "price_per_delivery_cents": 0,
          "price_per_hour_cents": 0,
          "price_per_km_cents": 3200,
          "type": "Truck",
          "visitable_locations_for_feature": null
        }
      ],
      "priorities": [
        {"id": "Standard", "penalty_factor": 10},
        {"id": "Urgent", "penalty_factor": 100}
      ]
    };

    return object;
  }*/

  getSolution(index) async {
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
            print('Manifest not found');
          }
        } else {
          _dialogService.showDialog(
              title: 'In Progress!',
              description:
                  'Your optimization is currently in progress. It\'ll just take a few minutes');
          print('Display to user that optimization is not ready');
        }
      }
    }
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
