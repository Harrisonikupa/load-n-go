import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loadngo/app/app.locator.dart';
import 'package:loadngo/models/address.model.dart';
import 'package:loadngo/models/configuration.model.dart';
import 'package:loadngo/models/objective.model.dart';
import 'package:loadngo/models/route-optimization-request.model.dart';
import 'package:loadngo/models/route-optimization-response.model.dart';
import 'package:loadngo/models/routing.model.dart';
import 'package:loadngo/models/service.model.dart';
import 'package:loadngo/models/time-window.model.dart';
import 'package:loadngo/models/vehicle-type.model.dart';
import 'package:loadngo/models/vehicle.model.dart';
import 'package:loadngo/services/Thirdparty/grasshopper.service.dart';
import 'package:loadngo/ui/styles/colors.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:uuid/uuid.dart';

class DeliveriesViewModel extends BaseViewModel {
  final formKey = GlobalKey<FormState>();
  final pickupLocationController = TextEditingController();
  final deliveryLocationController = TextEditingController();
  String? totalDistance = '';
  String? overallTime = '';
  RouteOptimizationResponse _solvedOptimizationResponse =
      new RouteOptimizationResponse();
  RouteOptimizationResponse get solvedOptimizationResponse =>
      _solvedOptimizationResponse;
  Position currentPosition = new Position(
      longitude: 1,
      latitude: 1,
      timestamp: null,
      accuracy: 1,
      altitude: 1,
      heading: 1,
      speed: 1,
      speedAccuracy: 1);
  String currentAddress = '';
  var uuid = Uuid();

  // Completer<GoogleMapController> controller = Completer();
  late GoogleMapController controller;
  final navigationService = locator<NavigationService>();
  final GrasshopperService _grasshopperService = locator<GrasshopperService>();

  late BitmapDescriptor sourceIcon;
  late BitmapDescriptor destinationIcon;
  Set<Marker> markers = Set<Marker>();

  final double CAMERA_ZOOM = 16;
  final double CAMERA_TILT = 80;
  final double CAMERA_BEARING = 30;

  late LatLng currentLocation;
  late LatLng destinationLocation;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  late PolylinePoints polylinePoints;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  String startAddress = '';
  String destinationAddress = '';
  String? placeDistance;

  //Optimization Constants
  void navigateBack() => navigationService.back();

  void modelIsReady() async {
    getCurrentLocation();
    polylinePoints = PolylinePoints();
  }

  void getCurrentLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      currentPosition = position;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: CAMERA_ZOOM,
          ),
        ),
      );
      notifyListeners();
      await getAddress();
    }).catchError((e) {});
  }

  getAddress() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
          currentPosition.latitude, currentPosition.longitude);

      Placemark place = p[0];

      currentAddress =
          "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";
      pickupLocationController.text = currentAddress;
      // startAddress = currentAddress;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  optimizeRoute(startLongitude, startLatitude, destinationLongitude,
      destinationLatitude) async {
    final isValid = formKey.currentState!.validate();
    final routeOptimizationRequest = new RouteOptimizationRequest();
    var services = new Service();
    var services2 = new Service();
    var objectives = new Objective();
    var configuration = new Configuration();
    if (isValid) {
      // Vehicle Object
      var vehicle = new Vehicle();
      vehicle.earliestStart = 1548836494;
      vehicle.maxJobs = 3;
      vehicle.vehicleId = uuid.v4();
      var startAddress = new Address();
      startAddress.locationId = uuid.v4();
      startAddress.lon = currentPosition.longitude;
      startAddress.lat = currentPosition.latitude;
      vehicle.startAddress = startAddress;
      vehicle.typeId = 'cargo-bike';

      // Vehicle Types
      var vehicleType = new VehicleType();
      vehicleType.typeId = 'cargo-bike';
      vehicleType.capacity = [10];
      vehicleType.profile = 'bike';

      // Services
      services.id = uuid.v4();
      services.name = 'visit-joe';
      var serviceAddress = new Address();
      serviceAddress.locationId = '${startLatitude}_$startLongitude';
      serviceAddress.lon = startLongitude;
      serviceAddress.lat = startLatitude;
      services.address = serviceAddress;
      services.size = [1];
      var timeWindow = new TimeWindow();
      timeWindow.earliest = 1554805329;
      timeWindow.latest = 1554806329;
      services.timeWindows = [timeWindow];

      // Services
      services2.id = uuid.v4();
      services2.name = 'visit-ken';
      var serviceAddress2 = new Address();
      serviceAddress2.locationId =
          '${destinationLatitude}_$destinationLongitude';
      serviceAddress2.lon = destinationLongitude;
      serviceAddress2.lat = destinationLatitude;
      services2.address = serviceAddress2;
      services2.size = [1];

      // Objectives
      objectives.type = 'min';
      objectives.value = 'vehicles';

      //Configuration
      var routing = new RoutingModel();
      routing.calcPoints = true;
      routing.snapPreventions = [
        "motorway",
        "trunk",
        "tunnel",
        "bridge",
        "ferry"
      ];
      configuration.routing = routing;

      // Adding all parameters to the route optimization request object
      routeOptimizationRequest.vehicles = [vehicle];

      routeOptimizationRequest.vehicleTypes = [vehicleType];

      routeOptimizationRequest.shipments = [];

      routeOptimizationRequest.services = [services, services2];

      routeOptimizationRequest.objectives = [];

      routeOptimizationRequest.configuration = configuration;

      navigationService.back();

      var result = await _grasshopperService
          .solveVehicleRoutingProblem(routeOptimizationRequest);

      if (result is RouteOptimizationResponse) {
        _solvedOptimizationResponse = result;
        totalDistance =
            (_solvedOptimizationResponse.solution!.distance! / 1000).toString();
        overallTime =
            (_solvedOptimizationResponse.solution!.transportTime! / 60)
                .toString();
        _solvedOptimizationResponse.solution!.routes![0].points!
            .forEach((coordinates) {
          coordinates.coordinates!.forEach((element) {
            polylineCoordinates.add(LatLng(element[1], element[0]));

            PolylineId id = PolylineId(uuid.v4());
            Polyline polyline = Polyline(
              polylineId: id,
              color: primaryColor,
              points: polylineCoordinates,
              width: 4,
            );
            polylines[id] = polyline;
          });
        });
        notifyListeners();
      }
    }
  }

  Future<bool> calculateDistance() async {
    try {
      List<Location> startPlacemark = await locationFromAddress(startAddress);
      List<Location> destinationPlacemark =
          await locationFromAddress(destinationAddress);

      double startLatitude = startAddress == currentAddress
          ? currentPosition.latitude
          : startPlacemark[0].latitude;

      double startLongitude = startAddress == currentAddress
          ? currentPosition.longitude
          : startPlacemark[0].longitude;

      double destinationLatitude = destinationPlacemark[0].latitude;
      double destinationLongitude = destinationPlacemark[0].longitude;

      String startCoordinatesString = '($startLatitude, $startLongitude)';
      String destinationCoordinatesString =
          '($destinationLatitude, $destinationLongitude)';

      Marker startMarker = Marker(
        markerId: MarkerId(startCoordinatesString),
        position: LatLng(startLatitude, startLongitude),
        infoWindow: InfoWindow(
          title: 'Start $startCoordinatesString',
          snippet: startAddress,
        ),
        icon: BitmapDescriptor.defaultMarker,
      );

      // Destination Location Marker
      Marker destinationMarker = Marker(
        markerId: MarkerId(destinationCoordinatesString),
        position: LatLng(destinationLatitude, destinationLongitude),
        infoWindow: InfoWindow(
          title: 'Destination $destinationCoordinatesString',
          snippet: destinationAddress,
        ),
        icon: BitmapDescriptor.defaultMarker,
      );

      // Adding the markers to the list
      markers.add(startMarker);
      markers.add(destinationMarker);

      double miny = (startLatitude <= destinationLatitude)
          ? startLatitude
          : destinationLatitude;
      double minx = (startLongitude <= destinationLongitude)
          ? startLongitude
          : destinationLongitude;
      double maxy = (startLatitude <= destinationLatitude)
          ? destinationLatitude
          : startLatitude;
      double maxx = (startLongitude <= destinationLongitude)
          ? destinationLongitude
          : startLongitude;

      double southWestLatitude = miny;
      double southWestLongitude = minx;

      double northEastLatitude = maxy;
      double northEastLongitude = maxx;

      controller.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
            northeast: LatLng(northEastLatitude, northEastLongitude),
            southwest: LatLng(southWestLatitude, southWestLongitude),
          ),
          100.0,
        ),
      );

      optimizeRoute(startLongitude, startLatitude, destinationLongitude,
          destinationLatitude);
      notifyListeners();
      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }
}
