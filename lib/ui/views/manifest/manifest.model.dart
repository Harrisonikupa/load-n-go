import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:loadngo/app/app.locator.dart';
import 'package:loadngo/models/goloop/job/job-details.model.dart';
import 'package:loadngo/models/goloop/job/manifest.model.dart';
import 'package:loadngo/models/goloop/single-models/drivers-manifest.model.dart';
import 'package:loadngo/models/goloop/single-models/manifest-item.model.dart';
import 'package:loadngo/services/Thirdparty/goloop.service.dart';
import 'package:loadngo/services/firebase/firestore.service.dart';
import 'package:loadngo/shared/storage/shared-preferences.storage.dart';
import 'package:loadngo/ui/responsiveness/sizing.config.dart';
import 'package:loadngo/ui/styles/colors.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:uuid/uuid.dart';

class ManifestViewModel extends BaseViewModel {
  final NavigationService navigationService = locator<NavigationService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final DialogService _dialogService = locator<DialogService>();
  final GoloopService _goloopService = locator<GoloopService>();

  List<BitmapDescriptor> markerIcons = <BitmapDescriptor>[];

  var uuid = Uuid();
  var driverId;
  int? currentTab = 0;
  Manifest manifest = new Manifest();
  JobDetails job = new JobDetails();
  List<ManifestItem> manifestList = <ManifestItem>[];
  List<DriversManifest> driversManifest = <DriversManifest>[];
  late GoogleMapController controller;
  final double CAMERA_ZOOM = 12;
  final double CAMERA_TILT = 20;
  final double CAMERA_BEARING = 30;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  Set<Marker> markers = Set<Marker>();
  var counter = new List.filled(100, null, growable: true);
  int? pageIndex = 0;
  List<Color> polylineColors = [
    primaryColor,
    blueColor,
    errorRedColor,
    successGreenColor
  ];

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
    } else {
      print('get job');
    }
    // await setCustomMarkers();
    await getLocationDetails();

    driverId = driversManifest[0].vehicle;
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
      } else {}
    });

    return LatLng(coordinateLat, coordinateLng);
  }

  getLocationDetails() async {
    setBusy(true);
    if (manifest.manifest![0].route!.isNotEmpty) {
      manifest.manifest?.asMap().forEach((manifestIndex, mani) {
        List<ManifestItem> manifestList2 = <ManifestItem>[];
        mani.route!.asMap().forEach((index, rou) async {
          ManifestItem item = new ManifestItem();
          item.arrivalTime = rou.arriveAfter;
          item.departureTime = rou.departBy;
          item.longitude = getLocationCoordinates(rou.location).longitude;
          item.latitude = getLocationCoordinates(rou.location).latitude;
          await getAddress(item.latitude, item.longitude)
              .then((value) => item.address = value.addressLine);
          manifestList.add(item);
          manifestList2.add(item);
          notifyListeners();
          final Uint8List markerIcon;
          if (index == 0 || index == mani.route!.length - 1) {
            markerIcon = await getBytesFromAsset('assets/images/0.png', 70);
          } else {
            markerIcon =
                await getBytesFromAsset('assets/images/$index.png', 70);
          }

          markers.add(
            Marker(
                markerId: MarkerId(uuid.v4()),
                position: LatLng(item.latitude!, item.longitude!),
                infoWindow: InfoWindow(title: '${item.address}'),
                icon: BitmapDescriptor.fromBytes(markerIcon)),
          );
          polylineCoordinates.add(LatLng(item.latitude!, item.longitude!));
          PolylineId id = PolylineId(uuid.v4());
          Polyline polyline = Polyline(
            polylineId: id,
            color: polylineColors[manifestIndex],
            points: polylineCoordinates,
            width: 2,
          );
          print('$manifestIndex >>>>>>>>>>>>. manifest index');
          polylines[id] = polyline;
        });
        DriversManifest drivManifest = new DriversManifest();
        drivManifest.vehicle = mani.vehicle;
        drivManifest.manifestItems = manifestList2;

        driversManifest.add(drivManifest);
      });
    } else {
      _dialogService.showDialog(
          title: 'Success!',
          description:
              'All consignments were dropped due to inconvenient time');

      setBusy(false);
      return;
    }
    setBusy(false);
    return manifestList;
  }

  getTime(date) {
    final formattedDate =
        new DateFormat().add_jm().format(DateTime.parse(date));

    return formattedDate;
  }

  getDate(date) {
    final formattedDate =
        new DateFormat().add_yMMMd().format(DateTime.parse(date));

    return formattedDate;
  }

  Future<Address> getAddress(latitude, longitude) async {
    var coordinates = new Coordinates(latitude, longitude);

    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);

    return addresses.first;
  }

  final markerKey = GlobalKey();

  // setCustomMarkers() async {
  //   counter.asMap().forEach((index, image) async {
  //     BitmapDescriptor iconPin = await BitmapDescriptor.fromAssetImage(
  //         ImageConfiguration(devicePixelRatio: 1.0),
  //         'assets/images/$index.png');
  //     markerIcons.add(iconPin);
  //   });
  // }

  // setCustomMarkersSizable() async {
  //   counter.asMap().forEach((index, image) async {
  //     Uint8List markerIcon =
  //         await getBytesFromAsset('assets/images/$index.png', 120);
  //     BitmapDescriptor iconPin = BitmapDescriptor.fromBytes(markerIcon);
  //     markerIcons.add(iconPin);
  //   });
  // }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Widget manifestListWidget(List<ManifestItem> manifest, context) {
    driversManifest.forEach((element) {
      print(element.manifestItems!.length);
    });
    // print(manifest);
    SizeConfig().init(context);
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: manifest.length,
        itemBuilder: (context, index) => Container(
          margin: new EdgeInsets.only(
            bottom: getProportionateScreenWidth(10),
          ),
          padding: new EdgeInsets.all(
            getProportionateScreenWidth(20),
          ),
          width: double.infinity,
          height: getProportionateScreenHeight(100),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: primaryColor, width: 2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              index == 0 || (index == manifest.length - 1)
                  ? Image.asset(
                      'assets/images/0.png',
                      width: getProportionateScreenWidth(30),
                      height: getProportionateScreenWidth(30),
                    )
                  : Container(
                      height: getProportionateScreenWidth(30),
                      width: getProportionateScreenWidth(30),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          '$index',
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: getProportionateScreenWidth(18),
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: whiteColor,
                        border: Border.all(color: primaryColor, width: 3),
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
              SizedBox(
                width: getProportionateScreenWidth(20),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: getProportionateScreenHeight(10),
                  ),
                  Padding(
                    padding: new EdgeInsets.only(right: 30),
                    child: FittedBox(
                      child: Text(
                        '${manifest[index].address}',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(12),
                          fontWeight: FontWeight.w800,
                          color: blackColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: getProportionateScreenWidth(8),
                  ),
                  Text(
                    '${getTime(manifest[index].arrivalTime)} - ${getTime(manifest[index].departureTime)}',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: getProportionateScreenWidth(12),
                        color: borderGreyColor),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  changeDriverId(value) async {
    driverId = driversManifest[value].vehicle;
    pageIndex = value;
    notifyListeners();
  }
}
