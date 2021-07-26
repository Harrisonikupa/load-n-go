import 'package:flutter/material.dart';
import 'package:loadngo/ui/responsiveness/sizing.config.dart';
import 'package:loadngo/ui/styles/colors.dart';
import 'package:loadngo/ui/views/optimized-route-view/optimized-route.model.dart';
import 'package:stacked/stacked.dart';

class OptimizedRouteView extends StatelessWidget {
  const OptimizedRouteView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return ViewModelBuilder<OptimizedRouteViewModel>.reactive(
      onModelReady: (model) => model.modelIsReady(),
      builder: (context, model, child) => SafeArea(
        child: Scaffold(
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
                      'Optimized Routes',
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
                  child: ListView(
                    children: [
                      Container(
                        color: Colors.red,
                        width: double.infinity,
                        height: 150.0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      viewModelBuilder: () => OptimizedRouteViewModel(),
    );
  }
}
