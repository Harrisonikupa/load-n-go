import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loadngo/ui/views/dummy/dummy.model.dart';
import 'package:stacked/stacked.dart';

class DummyView extends StatelessWidget {
  const DummyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return ViewModelBuilder<DummyViewModel>.reactive(
      onModelReady: (model) => model.getCurrentLocation(),
      builder: (context, model, child) => Container(
        height: height,
        width: width,
        child: Scaffold(
          key: model.scaffoldKey,
          body: Stack(
            children: <Widget>[
              // Map View
              GoogleMap(
                markers: Set<Marker>.from(model.markers),
                initialCameraPosition: model.initialLocation,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                mapType: MapType.normal,
                zoomGesturesEnabled: true,
                zoomControlsEnabled: false,
                polylines: Set<Polyline>.of(model.polylines.values),
                onMapCreated: (GoogleMapController controller) {
                  model.mapController = controller;
                },
              ),
              // Show zoom buttons
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ClipOval(
                        child: Material(
                          color: Colors.blue.shade100, // button color
                          child: InkWell(
                            splashColor: Colors.blue, // inkwell color
                            child: SizedBox(
                              width: 50,
                              height: 50,
                              child: Icon(Icons.add),
                            ),
                            onTap: () {
                              model.mapController.animateCamera(
                                CameraUpdate.zoomIn(),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      ClipOval(
                        child: Material(
                          color: Colors.blue.shade100, // button color
                          child: InkWell(
                            splashColor: Colors.blue, // inkwell color
                            child: SizedBox(
                              width: 50,
                              height: 50,
                              child: Icon(Icons.remove),
                            ),
                            onTap: () {
                              model.mapController.animateCamera(
                                CameraUpdate.zoomOut(),
                              );
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              // Show the place input fields & button for
              // showing the route
              SafeArea(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.all(
                          Radius.circular(20.0),
                        ),
                      ),
                      width: width * 0.9,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              'Places',
                              style: TextStyle(fontSize: 20.0),
                            ),
                            SizedBox(height: 10),
                            textField(
                                label: 'Start',
                                hint: 'Choose starting point',
                                prefixIcon: Icon(Icons.looks_one),
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.my_location),
                                  onPressed: () {
                                    model.startAddressController.text =
                                        model.currentAddress;
                                    model.startAddress = model.currentAddress;
                                  },
                                ),
                                controller: model.startAddressController,
                                focusNode: model.startAddressFocusNode,
                                width: width,
                                locationCallback: (String value) {
                                  model.startAddress = value;
                                  model.notifyListeners();
                                }),
                            SizedBox(height: 10),
                            textField(
                                label: 'Destination',
                                hint: 'Choose destination',
                                prefixIcon: Icon(Icons.looks_two),
                                controller: model.destinationAddressController,
                                focusNode: model.desrinationAddressFocusNode,
                                width: width,
                                locationCallback: (String value) {
                                  model.destinationAddress = value;
                                  model.notifyListeners();
                                }),
                            SizedBox(height: 10),
                            Visibility(
                              visible:
                                  model.placeDistance == null ? false : true,
                              child: Text(
                                'DISTANCE: ${model.placeDistance} km',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            ElevatedButton(
                              onPressed: (model.startAddress != '' &&
                                      model.destinationAddress != '')
                                  ? () async {
                                      model.startAddressFocusNode.unfocus();
                                      model.desrinationAddressFocusNode
                                          .unfocus();
                                      if (model.markers.isNotEmpty)
                                        model.markers.clear();
                                      if (model.polylines.isNotEmpty)
                                        model.polylines.clear();
                                      if (model.polylineCoordinates.isNotEmpty)
                                        model.polylineCoordinates.clear();
                                      model.placeDistance = null;
                                      model.notifyListeners();
                                      model
                                          .calculateDistance()
                                          .then((isCalculated) {
                                        if (isCalculated) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'Distance Calculated Sucessfully'),
                                            ),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'Error Calculating Distance'),
                                            ),
                                          );
                                        }
                                      });
                                    }
                                  : null,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Show Route'.toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                  ),
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Show current location button
              SafeArea(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
                    child: ClipOval(
                      child: Material(
                        color: Colors.orange.shade100, // button color
                        child: InkWell(
                          splashColor: Colors.orange, // inkwell color
                          child: SizedBox(
                            width: 56,
                            height: 56,
                            child: Icon(Icons.my_location),
                          ),
                          onTap: () {
                            model.mapController.animateCamera(
                              CameraUpdate.newCameraPosition(
                                CameraPosition(
                                  target: LatLng(
                                    model.currentPosition.latitude,
                                    model.currentPosition.longitude,
                                  ),
                                  zoom: 18.0,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      viewModelBuilder: () => DummyViewModel(),
    );
  }

  Widget textField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required String hint,
    required double width,
    required Icon prefixIcon,
    Widget? suffixIcon,
    required Function(String) locationCallback,
  }) {
    return Container(
      width: width * 0.8,
      child: TextField(
        onChanged: (value) {
          locationCallback(value);
        },
        controller: controller,
        focusNode: focusNode,
        decoration: new InputDecoration(
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.grey.shade400,
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.blue.shade300,
              width: 2,
            ),
          ),
          contentPadding: EdgeInsets.all(15),
          hintText: hint,
        ),
      ),
    );
  }
}
