import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loadngo/ui/responsiveness/sizing.config.dart';
import 'package:loadngo/ui/styles/colors.dart';
import 'package:loadngo/ui/views/manifest/manifest.model.dart';
import 'package:stacked/stacked.dart';

class ManifestView extends StatelessWidget {
  const ManifestView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return ViewModelBuilder<ManifestViewModel>.reactive(
      onModelReady: (model) => model.modelIsReady(),
      builder: (context, model, child) => SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: new EdgeInsets.symmetric(
              vertical: getProportionateScreenWidth(
                15.0,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: new EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: model.navigationService.back,
                        child: Container(
                          padding: new EdgeInsets.all(
                              getProportionateScreenWidth(5.0)),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(
                              getProportionateScreenWidth(10.0),
                            ),
                          ),
                          child: SvgPicture.asset(
                            'assets/images/back.svg',
                            color: whiteColor,
                          ),
                        ),
                      ),
                      Text(
                        'Route Optimization',
                        // textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: getProportionateScreenHeight(16.0),
                          color: primaryColor,
                        ),
                      ),
                      Container()
                    ],
                  ),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(15.0),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () => model.changeTab(0),
                      child: Container(
                        padding:
                            new EdgeInsets.all(getProportionateScreenWidth(20)),
                        width: MediaQuery.of(context).size.width / 2,
                        child: Text(
                          'Stops (${model.manifestList.length})',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: model.currentTab == 0
                                ? whiteColor
                                : primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        decoration: BoxDecoration(
                          color:
                              model.currentTab == 0 ? primaryColor : whiteColor,
                          border: Border.all(
                            color: model.currentTab == 0
                                ? whiteColor
                                : primaryColor,
                            width: model.currentTab == 0 ? 2 : 0,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => model.changeTab(1),
                      child: Container(
                        padding:
                            new EdgeInsets.all(getProportionateScreenWidth(20)),
                        width: (MediaQuery.of(context).size.width / 2),
                        child: Text(
                          'Map',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: model.currentTab == 1
                                ? whiteColor
                                : primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        decoration: BoxDecoration(
                          color:
                              model.currentTab == 1 ? primaryColor : whiteColor,
                          border: Border.all(
                            color: model.currentTab == 1
                                ? whiteColor
                                : primaryColor,
                            width: model.currentTab == 1 ? 2 : 0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                model.currentTab == 0
                    ? Expanded(
                        child: Padding(
                          padding: new EdgeInsets.all(
                              getProportionateScreenWidth(8)),
                          child: ListView.builder(
                            itemCount: model.manifestList.length,
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
                                border:
                                    Border.all(color: primaryColor, width: 2),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    height: getProportionateScreenWidth(30),
                                    width: getProportionateScreenWidth(30),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        '${index + 1}',
                                        style: TextStyle(
                                          color: primaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              getProportionateScreenWidth(18),
                                        ),
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      color: whiteColor,
                                      border: Border.all(
                                          color: primaryColor, width: 3),
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                  ),
                                  SizedBox(
                                    width: getProportionateScreenWidth(20),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height:
                                            getProportionateScreenHeight(10),
                                      ),
                                      Padding(
                                        padding: new EdgeInsets.only(right: 30),
                                        child: FittedBox(
                                          child: Text(
                                            '${model.manifestList[index].address}',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontSize:
                                                  getProportionateScreenWidth(
                                                      12),
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
                                        '${model.getTime(model.manifestList[index].arrivalTime)} - ${model.getTime(model.manifestList[index].departureTime)}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize:
                                                getProportionateScreenWidth(12),
                                            color: borderGreyColor),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    : Expanded(
                        child: Stack(
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
                              polylines:
                                  Set<Polyline>.of(model.polylines.values),
                              initialCameraPosition: CameraPosition(
                                target: LatLng(model.manifestList[0].latitude!,
                                    model.manifestList[2].longitude!),
                                bearing: model.CAMERA_BEARING,
                                // tilt: model.CAMERA_TILT,
                                zoom: model.CAMERA_ZOOM,
                              ),
                              onMapCreated: (GoogleMapController controller) {
                                model.controller = controller;
                              },
                            ),
                          ),
                          Positioned(
                              top: 0,
                              bottom: getProportionateScreenWidth(590),
                              left: getProportionateScreenWidth(80),
                              right: getProportionateScreenWidth(80),
                              child: Container(
                                width: getProportionateScreenWidth(100),
                                height: getProportionateScreenWidth(50),
                                decoration: BoxDecoration(
                                  color: whiteColor,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Total Distance',
                                      style: TextStyle(
                                          color: darkGreyColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    SizedBox(
                                      height: getProportionateScreenHeight(5),
                                    ),
                                    Text(
                                      '${(model.manifest.manifest![0].distanceTotalMetres / 1000).toStringAsFixed(2)}KM',
                                      style: TextStyle(
                                          color: darkGreyColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    )
                                  ],
                                ),
                              ))
                        ],
                      )),
              ],
            ),
          ),
        ),
      ),
      viewModelBuilder: () => ManifestViewModel(),
    );
  }
}
