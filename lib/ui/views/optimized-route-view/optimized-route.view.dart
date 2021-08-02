import 'package:flutter/material.dart';
import 'package:loadngo/ui/responsiveness/sizing.config.dart';
import 'package:loadngo/ui/styles/colors.dart';
import 'package:loadngo/ui/views/optimized-route-view/optimized-route.model.dart';
import 'package:loadngo/ui/widgets/loader.dart';
import 'package:stacked/stacked.dart';

class OptimizedRouteView extends StatelessWidget {
  const OptimizedRouteView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return ViewModelBuilder<OptimizedRouteViewModel>.reactive(
      onModelReady: (model) => model.modelIsReady(),
      builder: (context, model, child) => SafeArea(
        child: model.isBusy
            ? Loader()
            : Scaffold(
                backgroundColor: Colors.white,
                floatingActionButton: FloatingActionButton(
                  child: Icon(
                    Icons.add,
                    size: getProportionateScreenWidth(30),
                  ),
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(getProportionateScreenWidth(21.0)),
                    ),
                  ),
                  // onPressed: () => {},
                  onPressed: () => model.createJob(),
                ),
                body: Padding(
                  padding: new EdgeInsets.all(
                    getProportionateScreenWidth(
                      15.0,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(),
                          Text(
                            'List of Jobs',
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
                      SizedBox(
                        height: getProportionateScreenHeight(15.0),
                      ),
                      Expanded(
                        child: GridView.count(
                          // Create a grid with 2 columns. If you change the scrollDirection to
                          // horizontal, this produces 2 rows.
                          crossAxisCount: 4,
                          // Generate 100 widgets that display their index in the List.
                          children: List.generate(model.jobs.length, (index) {
                            return InkWell(
                              onTap: () => model.getSolution(index),
                              child: Container(
                                width: double.infinity,
                                height: getProportionateScreenWidth(60),
                                decoration: BoxDecoration(
                                  color: whiteColor,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        offset: Offset(0, 3),
                                        color: Color(0xFF35B8BE),
                                        blurRadius: 8.0)
                                  ],
                                ),
                                margin: new EdgeInsets.all(
                                  getProportionateScreenWidth(10),
                                ),
                                padding: new EdgeInsets.all(
                                    getProportionateScreenWidth(10)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Job ID: ${model.jobs[index].jobId}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize:
                                            getProportionateScreenWidth(10),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                      )
                    ],
                  ),
                ),
              ),
      ),
      viewModelBuilder: () => OptimizedRouteViewModel(),
    );
  }

  // Widget makeDismissible(
  //         {required Widget child, OptimizedRouteViewModel? model}) =>
  //     GestureDetector(
  //       behavior: HitTestBehavior.opaque,
  //       onTap: model!.navigateBack,
  //       child: GestureDetector(
  //         onTap: () {},
  //         child: child,
  //       ),
  //     );
  // Widget editOrderInformationBuildSheet(
  //         OptimizedRouteViewModel model, BuildContext context) =>
  //     makeDismissible(
  //         child: DraggableScrollableSheet(
  //           initialChildSize: 0.8,
  //           maxChildSize: 0.8,
  //           minChildSize: 0.6,
  //           builder: (_, controller) => Container(
  //               decoration: BoxDecoration(
  //                 color: Colors.white,
  //                 borderRadius: BorderRadius.vertical(
  //                   top: Radius.circular(
  //                     getProportionateScreenWidth(16),
  //                   ),
  //                 ),
  //               ),
  //               // padding: new EdgeInsets.all(16.0),
  //               child: Column(
  //                 children: [
  //                   SizedBox(
  //                     width: double.infinity,
  //                     height: getProportionateScreenHeight(50),
  //                     child: Container(
  //                       padding: new EdgeInsets.symmetric(
  //                           horizontal: getProportionateScreenWidth(10)),
  //                       decoration: BoxDecoration(
  //                         borderRadius: BorderRadius.vertical(
  //                           top: Radius.circular(
  //                             getProportionateScreenWidth(16),
  //                           ),
  //                         ),
  //                         color: primaryColor,
  //                       ),
  //                       child: Row(
  //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                         children: [
  //                           Text(
  //                             'Vehicle Information',
  //                             style: TextStyle(
  //                                 fontSize: getProportionateScreenWidth(16.0),
  //                                 fontWeight: FontWeight.w700,
  //                                 color: Colors.white),
  //                           ),
  //                           IconButton(
  //                               onPressed: model.navigateBack,
  //                               icon: Icon(
  //                                 Icons.close,
  //                                 color: Colors.white,
  //                                 size: getProportionateScreenWidth(24),
  //                               ))
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                   Expanded(
  //                     child: Padding(
  //                       padding: new EdgeInsets.all(
  //                         getProportionateScreenWidth(10),
  //                       ),
  //                       child: SingleChildScrollView(
  //                         child: Form(
  //                           key: model.formKey,
  //                           autovalidateMode:
  //                               AutovalidateMode.onUserInteraction,
  //                           child: Column(
  //                             children: [
  //                               InkWell(
  //                                 onTap: () {
  //                                   DatePicker.showTimePicker(context,
  //                                       theme: DatePickerTheme(
  //                                           backgroundColor: Colors.white),
  //                                       onChanged: (time) {
  //                                     print(time);
  //                                   });
  //                                 },
  //                                 child: Row(
  //                                   children: [
  //                                     TextInput(
  //                                       labelText: 'Available from',
  //                                       isEnabled: false,
  //                                       hintText: 'Availability time',
  //                                       controller:
  //                                           model.availableFromController,
  //                                     ),
  //                                     TextInput(
  //                                       labelText: 'Available until',
  //                                       isEnabled: false,
  //                                       controller:
  //                                           model.availableUntilController,
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                               SizedBox(
  //                                 height: getProportionateScreenHeight(20.0),
  //                               ),
  //                               TextInput(
  //                                 labelText: 'Maximum capacity in KG',
  //                                 controller: model.maximumCapacityController,
  //                               ),
  //                               SizedBox(
  //                                 height: getProportionateScreenHeight(
  //                                   20.0,
  //                                 ),
  //                               ),
  //                               TextInput(
  //                                 labelText: 'Maximum distance in KM?',
  //                                 controller: model.maximumDistanceController,
  //                               ),
  //                               SizedBox(
  //                                 height: getProportionateScreenHeight(
  //                                   20.0,
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                     flex: 12,
  //                   ),
  //                   Expanded(
  //                     flex: 2,
  //                     child: SubmitButton(
  //                       onSubmit: () => model.createJob,
  //                       borderColor: primaryColor,
  //                       buttonColor: primaryColor,
  //                       buttonText: 'Update Order',
  //                       textColor: Colors.white,
  //                     ),
  //                   )
  //                 ],
  //               )),
  //         ),
  //         model: model);
}
