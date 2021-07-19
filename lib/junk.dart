// CameraPosition initialLocation = CameraPosition(target: LatLng(0.0, 0.0));
// late GoogleMapController mapController;
//
// late Position currentPosition;
// String currentAddress = '';
//
// final startAddressController = TextEditingController();
// final destinationAddressController = TextEditingController();
//
// final startAddressFocusNode = FocusNode();
// final desrinationAddressFocusNode = FocusNode();
//
// String startAddress = '';
// String destinationAddress = '';
// String? placeDistance;
//
// Set<Marker> markers = {};
//
// late PolylinePoints polylinePoints;
// Map<PolylineId, Polyline> polylines = {};
// List<LatLng> polylineCoordinates = [];
//
// final scaffoldKey = GlobalKey<ScaffoldState>();
//
// // Method for retrieving the current location
// getCurrentLocation() async {
//   await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
//       .then((Position position) async {
//     mapController.setMapStyle(Utils.mapStyle);
//
//     currentPosition = position;
//     mapController.animateCamera(
//       CameraUpdate.newCameraPosition(
//         CameraPosition(
//           target: LatLng(position.latitude, position.longitude),
//           zoom: 18.0,
//         ),
//       ),
//     );
//     notifyListeners();
//     await getAddress();
//   }).catchError((e) {
//     print(e);
//   });
// }
//
// // Method for retrieving the address
// getAddress() async {
//   try {
//     List<Placemark> p = await placemarkFromCoordinates(
//         currentPosition.latitude, currentPosition.longitude);
//
//     Placemark place = p[0];
//
//     currentAddress =
//     "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";
//     startAddressController.text = currentAddress;
//     startAddress = currentAddress;
//
//     notifyListeners();
//   } catch (e) {
//     print(e);
//   }
// }
//
// // Method for calculating the distance between two places
// Future<bool> calculateDistance() async {
//   try {
//     // Retrieving placemarks from addresses
//     List<Location> startPlacemark = await locationFromAddress(startAddress);
//     List<Location> destinationPlacemark =
//     await locationFromAddress(destinationAddress);
//
//     // Use the retrieved coordinates of the current position,
//     // instead of the address if the start position is user's
//     // current position, as it results in better accuracy.
//     double startLatitude = startAddress == currentAddress
//         ? currentPosition.latitude
//         : startPlacemark[0].latitude;
//
//     double startLongitude = startAddress == currentAddress
//         ? currentPosition.longitude
//         : startPlacemark[0].longitude;
//
//     double destinationLatitude = destinationPlacemark[0].latitude;
//     double destinationLongitude = destinationPlacemark[0].longitude;
//
//     String startCoordinatesString = '($startLatitude, $startLongitude)';
//     String destinationCoordinatesString =
//         '($destinationLatitude, $destinationLongitude)';
//
//     // Start Location Marker
//     Marker startMarker = Marker(
//       markerId: MarkerId(startCoordinatesString),
//       position: LatLng(startLatitude, startLongitude),
//       infoWindow: InfoWindow(
//         title: 'Start $startCoordinatesString',
//         snippet: startAddress,
//       ),
//       icon: BitmapDescriptor.defaultMarker,
//     );
//
//     // Destination Location Marker
//     Marker destinationMarker = Marker(
//       markerId: MarkerId(destinationCoordinatesString),
//       position: LatLng(destinationLatitude, destinationLongitude),
//       infoWindow: InfoWindow(
//         title: 'Destination $destinationCoordinatesString',
//         snippet: destinationAddress,
//       ),
//       icon: BitmapDescriptor.defaultMarker,
//     );
//
//     // Adding the markers to the list
//     markers.add(startMarker);
//     markers.add(destinationMarker);
//
//     print(
//       'START COORDINATES: ($startLatitude, $startLongitude)',
//     );
//     print(
//       'DESTINATION COORDINATES: ($destinationLatitude, $destinationLongitude)',
//     );
//
//     // Calculating to check that the position relative
//     // to the frame, and pan & zoom the camera accordingly.
//     double miny = (startLatitude <= destinationLatitude)
//         ? startLatitude
//         : destinationLatitude;
//     double minx = (startLongitude <= destinationLongitude)
//         ? startLongitude
//         : destinationLongitude;
//     double maxy = (startLatitude <= destinationLatitude)
//         ? destinationLatitude
//         : startLatitude;
//     double maxx = (startLongitude <= destinationLongitude)
//         ? destinationLongitude
//         : startLongitude;
//
//     double southWestLatitude = miny;
//     double southWestLongitude = minx;
//
//     double northEastLatitude = maxy;
//     double northEastLongitude = maxx;
//
//     // Accommodate the two locations within the
//     // camera view of the map
//     mapController.animateCamera(
//       CameraUpdate.newLatLngBounds(
//         LatLngBounds(
//           northeast: LatLng(northEastLatitude, northEastLongitude),
//           southwest: LatLng(southWestLatitude, southWestLongitude),
//         ),
//         100.0,
//       ),
//     );
//
//     // Calculating the distance between the start and the end positions
//     // with a straight path, without considering any route
//     // double distanceInMeters = await Geolocator.bearingBetween(
//     //   startLatitude,
//     //   startLongitude,
//     //   destinationLatitude,
//     //   destinationLongitude,
//     // );
//
//     await createPolylines(startLatitude, startLongitude, destinationLatitude,
//         destinationLongitude);
//
//     double totalDistance = 0.0;
//
//     // Calculating the total distance by adding the distance
//     // between small segments
//     for (int i = 0; i < polylineCoordinates.length - 1; i++) {
//       totalDistance += coordinateDistance(
//         polylineCoordinates[i].latitude,
//         polylineCoordinates[i].longitude,
//         polylineCoordinates[i + 1].latitude,
//         polylineCoordinates[i + 1].longitude,
//       );
//     }
//
//     placeDistance = totalDistance.toStringAsFixed(2);
//     notifyListeners();
//     print('DISTANCE: $placeDistance km');
//
//     return true;
//   } catch (e) {
//     print(e);
//   }
//   return false;
// }
//
// // Formula for calculating distance between two coordinates
// // https://stackoverflow.com/a/54138876/11910277
// double coordinateDistance(lat1, lon1, lat2, lon2) {
//   var p = 0.017453292519943295;
//   var c = cos;
//   var a = 0.5 -
//       c((lat2 - lat1) * p) / 2 +
//       c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
//   return 12742 * asin(sqrt(a));
// }
//
// // Create the polylines for showing the route between two places
// createPolylines(
//     double startLatitude,
//     double startLongitude,
//     double destinationLatitude,
//     double destinationLongitude,
//     ) async {
//   polylinePoints = PolylinePoints();
//   PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//     Secrets.API_KEY, // Google Maps API Key
//     PointLatLng(startLatitude, startLongitude),
//     PointLatLng(destinationLatitude, destinationLongitude),
//     travelMode: TravelMode.transit,
//   );
//
//   if (result.points.isNotEmpty) {
//     result.points.forEach((PointLatLng point) {
//       polylineCoordinates.add(LatLng(point.latitude, point.longitude));
//     });
//   }
//
//   PolylineId id = PolylineId('poly');
//   Polyline polyline = Polyline(
//     polylineId: id,
//     color: Colors.red,
//     points: polylineCoordinates,
//     width: 3,
//   );
//   polylines[id] = polyline;
// }
//
// Widget textField({
//   required TextEditingController controller,
//   required FocusNode focusNode,
//   required String label,
//   required String hint,
//   required double width,
//   required Icon prefixIcon,
//   Widget? suffixIcon,
//   required Function(String) locationCallback,
// }) {
//   return Container(
//     width: width * 0.8,
//     child: TextField(
//       onChanged: (value) {
//         locationCallback(value);
//       },
//       controller: controller,
//       focusNode: focusNode,
//       decoration: new InputDecoration(
//         prefixIcon: prefixIcon,
//         suffixIcon: suffixIcon,
//         labelText: label,
//         filled: true,
//         fillColor: Colors.white,
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.all(
//             Radius.circular(10.0),
//           ),
//           borderSide: BorderSide(
//             color: Colors.grey.shade400,
//             width: 2,
//           ),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.all(
//             Radius.circular(10.0),
//           ),
//           borderSide: BorderSide(
//             color: Colors.blue.shade300,
//             width: 2,
//           ),
//         ),
//         contentPadding: EdgeInsets.all(15),
//         hintText: hint,
//       ),
//     ),
//   );
// }
//
// void setDestinationAddressValue(value) {
//   destinationAddress = value;
//   notifyListeners();
// }
//
// void setStartddressValue(value) {
//   startAddress = value;
//   notifyListeners();
// }
//
// void clearCoordinates() {
//   if (markers.isNotEmpty) markers.clear();
//   if (polylines.isNotEmpty) polylines.clear();
//   if (polylineCoordinates.isNotEmpty) polylineCoordinates.clear();
//   placeDistance = null;
// }

//------------------------------------------------------------------------------------------------

// return ViewModelBuilder<DeliveriesViewModel>.reactive(
// onModelReady: (model) => model.getCurrentLocation(),
// builder: (context, model, child) => Container(
// height: size.height,
// width: size.width,
// child: Scaffold(
// key: model.scaffoldKey,
// body: Stack(
// children: <Widget>[
// // Map View
// GoogleMap(
// markers: Set<Marker>.from(model.markers),
// initialCameraPosition: model.initialLocation,
// myLocationEnabled: true,
// myLocationButtonEnabled: false,
// mapType: MapType.normal,
// zoomGesturesEnabled: true,
// zoomControlsEnabled: false,
// polylines: Set<Polyline>.of(model.polylines.values),
// onMapCreated: (GoogleMapController controller) {
// model.mapController = controller;
// },
// ),
// // Show zoom buttons
// SafeArea(
// child: Padding(
// padding: const EdgeInsets.only(left: 10.0),
// child: Column(
// mainAxisAlignment: MainAxisAlignment.center,
// children: <Widget>[
// ClipOval(
// child: Material(
// color: Colors.blue.shade100, // button color
// child: InkWell(
// splashColor: Colors.blue, // inkwell color
// child: SizedBox(
// width: 50,
// height: 50,
// child: Icon(Icons.add),
// ),
// onTap: () {
// model.mapController.animateCamera(
// CameraUpdate.zoomIn(),
// );
// },
// ),
// ),
// ),
// SizedBox(height: 20),
// ClipOval(
// child: Material(
// color: Colors.blue.shade100, // button color
// child: InkWell(
// splashColor: Colors.blue, // inkwell color
// child: SizedBox(
// width: 50,
// height: 50,
// child: Icon(Icons.remove),
// ),
// onTap: () {
// model.mapController.animateCamera(
// CameraUpdate.zoomOut(),
// );
// },
// ),
// ),
// )
// ],
// ),
// ),
// ),
// // Show the place input fields & button for
// // showing the route
// SafeArea(
// child: Align(
// alignment: Alignment.topCenter,
// child: Padding(
// padding: const EdgeInsets.only(top: 10.0),
// child: Container(
// decoration: BoxDecoration(
// color: Colors.white70,
// borderRadius: BorderRadius.all(
// Radius.circular(20.0),
// ),
// ),
// width: size.width * 0.9,
// child: Padding(
// padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
// child: Column(
// mainAxisSize: MainAxisSize.min,
// children: <Widget>[
// Text(
// 'Places',
// style: TextStyle(fontSize: 20.0),
// ),
// SizedBox(height: 10),
// model.textField(
// label: 'Start',
// hint: 'Choose starting point',
// prefixIcon: Icon(Icons.looks_one),
// suffixIcon: IconButton(
// icon: Icon(Icons.my_location),
// onPressed: () {
// model.startAddressController.text =
// model.currentAddress;
// model.startAddress = model.currentAddress;
// },
// ),
// controller: model.startAddressController,
// focusNode: model.startAddressFocusNode,
// width: size.width,
// locationCallback: (String value) {
// model.setStartddressValue(value);
// }),
// SizedBox(height: 10),
// model.textField(
// label: 'Destination',
// hint: 'Choose destination',
// prefixIcon: Icon(Icons.looks_two),
// controller: model.destinationAddressController,
// focusNode: model.desrinationAddressFocusNode,
// width: size.width,
// locationCallback: (String value) {
// model.setDestinationAddressValue(value);
// }),
// SizedBox(height: 10),
// // Visibility(
// //   visible:
// //       model.placeDistance == null ? false : true,
// //   child: Text(
// //     'DISTANCE: ${model.placeDistance}km',
// //     style: TextStyle(
// //       fontSize: 16,
// //       fontWeight: FontWeight.bold,
// //     ),
// //   ),
// // ),
// SizedBox(height: 5),
// ElevatedButton(
// onPressed: (model.startAddress != '' &&
// model.destinationAddress != '')
// ? () async {
// model.startAddressFocusNode.unfocus();
// model.desrinationAddressFocusNode
//     .unfocus();
// model.clearCoordinates();
//
// model
//     .calculateDistance()
//     .then((isCalculated) {
// if (isCalculated) {
// // ScaffoldMessenger.of(context)
// //     .showSnackBar(
// //   SnackBar(
// //     content: Text(
// //         'Distance Calculated Successfully'),
// //   ),
// // );
// } else {
// // ScaffoldMessenger.of(context)
// //     .showSnackBar(
// //   SnackBar(
// //     content: Text(
// //         'Error Calculating Distance'),
// //   ),
// // );
// }
// });
// }
//     : null,
// child: Padding(
// padding: const EdgeInsets.all(8.0),
// child: Text(
// 'Optimize Route',
// style: TextStyle(
// color: Colors.white,
// fontSize: 20.0,
// ),
// ),
// ),
// style: ElevatedButton.styleFrom(
// primary: primaryColor,
// shape: RoundedRectangleBorder(
// borderRadius: BorderRadius.circular(10.0),
// ),
// ),
// ),
// ],
// ),
// ),
// ),
// ),
// ),
// ),
// // Show current location button
// SafeArea(
// child: Align(
// alignment: Alignment.bottomRight,
// child: Padding(
// padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
// child: ClipOval(
// child: Material(
// color: Colors.orange.shade100, // button color
// child: InkWell(
// splashColor: Colors.orange, // inkwell color
// child: SizedBox(
// width: 56,
// height: 56,
// child: Icon(Icons.my_location),
// ),
// onTap: () {
// model.mapController.animateCamera(
// CameraUpdate.newCameraPosition(
// CameraPosition(
// target: LatLng(
// model.currentPosition.latitude,
// model.currentPosition.longitude,
// ),
// zoom: 18.0,
// ),
// ),
// );
// },
// ),
// ),
// ),
// ),
// ),
// ),
// ],
// ),
// ),
// ),
// viewModelBuilder: () => DeliveriesViewModel(),
// );
