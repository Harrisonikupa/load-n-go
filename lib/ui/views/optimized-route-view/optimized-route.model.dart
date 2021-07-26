import 'package:geocoding/geocoding.dart';
import 'package:loadngo/app/app.locator.dart';
import 'package:loadngo/models/goloop/access-token/access-token-request.model.dart';
import 'package:loadngo/models/goloop/access-token/access-token-response.dart';
import 'package:loadngo/models/goloop/job/job-details.model.dart';
import 'package:loadngo/models/goloop/job/submitted-job.model.dart';
import 'package:loadngo/models/goloop/single-models/capacity-used.model.dart';
import 'package:loadngo/models/goloop/single-models/capacity.model.dart';
import 'package:loadngo/models/goloop/single-models/consignment.model.dart';
import 'package:loadngo/models/goloop/single-models/container.model.dart';
import 'package:loadngo/models/goloop/single-models/location.model.dart';
import 'package:loadngo/models/goloop/single-models/model-options.model.dart';
import 'package:loadngo/models/goloop/single-models/priority.model.dart';
import 'package:loadngo/models/goloop/single-models/vehicle.model.dart';
import 'package:loadngo/models/goloop/single-models/visitable-locations-for-features.model.dart';
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

  modelIsReady() async {
    print('started');
    await getAuthorizationToken();
    await fetchOrders();
    var response = await convertDeliveryAddressesToLongAndLat(orders);
    print('done');

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
        print('placing all in');
      });
    });
    return Future.delayed(Duration(seconds: 6), () => ordersWithCoordinates);
  }

  getAuthorizationToken() async {
    // Get authorization to goloop api
    AccessTokenRequest request = new AccessTokenRequest();
    request.username = Secrets.goloop_username;
    request.password = Secrets.goloop_password;
    request.grantType = Secrets.goloop_grant_type;
    var authorizationResponse = await _goloopService.getAccessToken(request);

    if (authorizationResponse is AccessTokenResponse) {
      DataStorage.setAccessToken(authorizationResponse);
    }
  }

  createJob() async {
    JobDetails job = new JobDetails();
    ModelOptions modelOptions = new ModelOptions();
    List<Consignment> consignments = <Consignment>[];
    List<Locations> locations = <Locations>[];
    List<Vehicle> vehicles = <Vehicle>[];
    List<Priority> priorities = <Priority>[];
    var uuid = Uuid();

    // Populate model options
    modelOptions.computeTimeMilliseconds = 10000;
    modelOptions.lateHourlyPenaltyCents = 0;
    modelOptions.workingTimeLimitMinutes = 0;
    modelOptions.timeWindows = 'soft';

    // Add model option to job object
    job.modelOptions = modelOptions;

    // Populate consignment/ vehicles
    refinedOrders.forEach((order) {
      Consignment consignment = new Consignment();
      consignment.id = uuid.v4();
      consignment.locationIdFrom = uuid.v4();
      consignment.locationIdTo = uuid.v4();
      consignment.priority = '';
      consignment.pickupTimeStartUtc =
          '${order.pickupDate}${Secrets.date_suffix}';
      consignment.pickupTimeEndUtc =
          '${order.pickupDate}${Secrets.date_suffix}';
      consignment.pickupServiceTimeMinutes = 0;
      consignment.pickupTimeWindowConstraint = 'soft';
      consignment.deliverTimeStartUtc =
          '${order.deliveryDate}${Secrets.date_suffix}';
      consignment.deliverTimeEndUtc =
          '${order.deliveryDate}${Secrets.date_suffix}';
      consignment.deliverServiceTimeMinutes = 0;
      consignment.deliverTimeWindowConstraint = 'soft';
      CapacitiesUsed capacitiesUsed = new CapacitiesUsed();
      capacitiesUsed.type = 'weight';
      capacitiesUsed.units = 'kg';
      capacitiesUsed.used = 0;
      consignment.capacitiesUsed = [capacitiesUsed];
      consignment.vehicleContainerTypeRequired = 'cold';
      consignment.vehicleFixedFeaturesRequired = [''];
      consignment.vehiclesAllowed = ['bike'];
      consignment.vehiclesRefused = [''];
      consignments.add(consignment);

      Locations location = new Locations();
      location.id = uuid.v4();
      location.latitude = order.latitude.toString();
      location.longitude = order.longitude.toString();
      location.availableFromUtc = '${order.pickupDate}${Secrets.date_suffix}';
      location.availableUntilUtc =
          '${order.deliveryDate}${Secrets.date_suffix}';
      location.vehiclesAllowed = ['bike'];
      location.vehicleTypesAllowed = [''];
      location.vehicleTypesRefused = [''];
      location.vehicleFeaturesRequired = [''];
      locations.add(location);
    });
    Vehicle vehicle = new Vehicle();
    vehicle.id = uuid.v4();
    vehicle.type = 'bike';
    vehicle.locationStartId = uuid.v4();
    vehicle.locationEndId = uuid.v4();
    vehicle.availableFromUtc =
        '${refinedOrders[0].pickupDate}${Secrets.date_suffix}';
    vehicle.availableUntilUtc =
        '${refinedOrders[refinedOrders.length - 1].pickupDate}${Secrets.date_suffix}';
    Container container = new Container();
    container.type = uuid.v4();
    Capacity capacity = new Capacity();
    capacity.type = uuid.v4();
    capacity.units = 'kg';
    capacity.maximum = 0;
    container.capacities = [capacity];
    vehicle.containers = [container];
    vehicle.fixedFeatures = ['trolley'];
    VisitableLocationsForFeature property = new VisitableLocationsForFeature();
    property.property1 = [''];
    property.property2 = [''];
    vehicle.visitableLocationsForFeature = property;

    vehicle.pricePerDeliveryCents = 0;
    vehicle.pricePerKmCents = 0;
    vehicle.pricePerHourCents = 0;
    vehicle.maxDistanceMetres = 1;
    vehicles.add(vehicle);

    Priority priority = new Priority();
    priority.id = uuid.v4();
    priority.penaltyFactor = 1;
    priorities.add(priority);

    job.modelOptions = modelOptions;
    job.consignments = consignments;
    job.locations = locations;
    job.vehicles = vehicles;
    job.priorities = priorities;

    print(job.toMap());

    var response = await _goloopService.postJob(job);

    if (response is SubmittedJob) {
      print(response.toMap());
    } else {
      print('Could not do that');
    }
  }
}
