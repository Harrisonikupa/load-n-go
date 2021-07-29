import 'dart:async';
import 'dart:convert';

import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:loadngo/app/app.locator.dart';
import 'package:loadngo/models/goloop/job/job-details.model.dart';
import 'package:loadngo/models/goloop/job/manifest.model.dart';
import 'package:loadngo/models/goloop/single-models/manifest-item.model.dart';
import 'package:loadngo/services/Thirdparty/goloop.service.dart';
import 'package:loadngo/services/firebase/firestore.service.dart';
import 'package:loadngo/shared/storage/shared-preferences.storage.dart';
import 'package:loadngo/ui/styles/colors.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:uuid/uuid.dart';

class ManifestViewModel extends BaseViewModel {
  final NavigationService navigationService = locator<NavigationService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final DialogService _dialogService = locator<DialogService>();
  final GoloopService _goloopService = locator<GoloopService>();

  var uuid = Uuid();
  int? currentTab = 0;
  Manifest manifest = new Manifest();
  JobDetails job = new JobDetails();
  List<ManifestItem> manifestList = <ManifestItem>[];
  late GoogleMapController controller;
  final double CAMERA_ZOOM = 16;
  final double CAMERA_TILT = 80;
  final double CAMERA_BEARING = 30;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  Set<Marker> markers = Set<Marker>();

  modelIsReady() async {
    if (DataStorage.containsKey(DataStorage.keyManifest)) {
      manifest = DataStorage.getManifest();
    } else {
      await _dialogService.showDialog(
          title: 'Error!', description: 'Unable to fetch manifest');
      navigationService.back();
    }
    if (DataStorage.containsKey(DataStorage.keyJob)) {
      job = DataStorage.getJob();
    }

    await getLocationDetails();
  }

  prettyObject(dynamic object) {
    final prettyString = JsonEncoder.withIndent(" ").convert(object);
    return prettyString;
  }

  changeTab(value) async {
    currentTab = value;
    notifyListeners();
  }

  LatLng getLocationCoordinates(id) {
    double coordinateLat = 0.0;
    double coordinateLng = 0.0;
    job.locations!.forEach((location) {
      if (location.id == id) {
        coordinateLat = double.parse(location.latitude!);
        coordinateLng = double.parse(location.longitude!);
      }
    });

    return LatLng(coordinateLat, coordinateLng);
  }

  getLocationDetails() async {
    manifest.manifest?.forEach((mani) {
      mani.route!.forEach((rou) async {
        ManifestItem item = new ManifestItem();
        item.arrivalTime = rou.arriveAfter;
        item.departureTime = rou.departBy;
        item.longitude = getLocationCoordinates(rou.location).longitude;
        item.latitude = getLocationCoordinates(rou.location).latitude;
        await getAddress(item.latitude, item.longitude)
            .then((value) => item.address = value.addressLine);
        manifestList.add(item);

        markers.add(Marker(
            markerId: MarkerId(uuid.v4()),
            position: LatLng(item.latitude!, item.longitude!),
            infoWindow: InfoWindow(title: 'The title of the marker')));
        polylineCoordinates.add(LatLng(item.latitude!, item.longitude!));
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

    return manifestList;
  }

  getTime(date) {
    final formattedDate =
        new DateFormat().add_jm().format(DateTime.parse(date));

    return formattedDate;
  }

  Future<Address> getAddress(latitude, longitude) async {
    var coordinates = new Coordinates(latitude, longitude);

    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);

    return addresses.first;
  }
}
