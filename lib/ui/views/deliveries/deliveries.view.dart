import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loadngo/shared/validators/validators.dart';
import 'package:loadngo/ui/responsiveness/sizing.config.dart';
import 'package:loadngo/ui/styles/colors.dart';
import 'package:loadngo/ui/views/deliveries/deliveries.model.dart';
import 'package:loadngo/ui/widgets/custom-button.dart';
import 'package:loadngo/ui/widgets/text-field.dart';
import 'package:stacked/stacked.dart';

class DeliveriesView extends StatelessWidget {
  const DeliveriesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return ViewModelBuilder<DeliveriesViewModel>.reactive(
      onModelReady: (model) => model.modelIsReady(),
      builder: (context, model, child) => SafeArea(
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            child: Icon(
              Icons.add,
              size: getProportionateScreenWidth(30),
            ),
            backgroundColor: primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
              Radius.circular(getProportionateScreenWidth(21.0)),
            )),
            // onPressed: () => {},
            onPressed: () => showModalBottomSheet(
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                context: context,
                builder: (context) => buildSheet(model)),
          ),
          body: Stack(
            children: [
              Positioned.fill(
                child: GoogleMap(
                  myLocationEnabled: true,
                  compassEnabled: true,
                  tiltGesturesEnabled: false,
                  markers: Set<Marker>.from(model.markers),
                  mapType: MapType.normal,
                  zoomGesturesEnabled: true,
                  zoomControlsEnabled: false,
                  polylines: Set<Polyline>.of(model.polylines.values),
                  initialCameraPosition: CameraPosition(
                    target: LatLng(model.currentPosition.latitude,
                        model.currentPosition.longitude),
                    bearing: model.CAMERA_BEARING,
                    // tilt: model.CAMERA_TILT,
                    zoom: model.CAMERA_ZOOM,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    model.controller = controller;
                    // model.controller.complete(controller);
                    // model.showPinsOnMap();
                    // model.setPolylines();
                  },
                ),
              ),
              Positioned(
                top: getProportionateScreenHeight(60),
                left: getProportionateScreenWidth(50),
                right: getProportionateScreenWidth(50),
                bottom: getProportionateScreenHeight(500),
                child: Opacity(
                  opacity: 0.5,
                  child: Container(
                    padding:
                        new EdgeInsets.all(getProportionateScreenWidth(10)),
                    decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(
                            getProportionateScreenWidth(10))),
                    width: 40.0,
                    height: 40.0,
                    child: Text('Hello'),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      viewModelBuilder: () => DeliveriesViewModel(),
    );
  }

  Widget makeDismissible({required Widget child, DeliveriesViewModel? model}) =>
      GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: model!.navigateBack,
        child: GestureDetector(
          onTap: () {},
          child: child,
        ),
      );
  Widget buildSheet(DeliveriesViewModel model) => makeDismissible(
      child: DraggableScrollableSheet(
        initialChildSize: 0.8,
        maxChildSize: 0.8,
        minChildSize: 0.6,
        builder: (_, controller) => Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(
                  getProportionateScreenWidth(16),
                ),
              ),
            ),
            // padding: new EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: getProportionateScreenHeight(50),
                  child: Container(
                    padding: new EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(10)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(
                          getProportionateScreenWidth(16),
                        ),
                      ),
                      color: primaryColor,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Please input order information',
                          style: TextStyle(
                              fontSize: getProportionateScreenWidth(16.0),
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                        IconButton(
                            onPressed: model.navigateBack,
                            icon: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: getProportionateScreenWidth(24),
                            ))
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: new EdgeInsets.all(
                      getProportionateScreenWidth(10),
                    ),
                    child: SingleChildScrollView(
                      child: Form(
                        key: model.formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          children: [
                            TextInput(
                              hintText: 'Input your address or postal code',
                              labelText: 'Pickup Address',
                              controller: model.pickupLocationController,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                return Validator.emptyField(value);
                              },
                              changed: (String value) {
                                model.startAddress = value;
                                model.notifyListeners();
                              },

                              // saved: ,
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(15.0),
                            ),
                            TextInput(
                              hintText: 'Input your address or postal code',
                              labelText: 'Delivery Address',
                              controller: model.deliveryLocationController,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                return Validator.emptyField(value);
                              },
                              changed: (String value) {
                                model.destinationAddress = value;
                                model.notifyListeners();
                              },
                              // saved: ,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  flex: 12,
                ),
                Expanded(
                  flex: 2,
                  child: SubmitButton(
                    textColor: Colors.white,
                    borderColor: primaryColor,
                    buttonColor: primaryColor,
                    onSubmit: model.calculateDistance,
                    buttonText: 'Optimize Route',
                  ),
                )
              ],
            )),
      ),
      model: model);
}
