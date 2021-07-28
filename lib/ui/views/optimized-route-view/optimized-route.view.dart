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
                    child: ListView.builder(
                  itemCount: model.jobs.length,
                  itemBuilder: (context, index) {
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
                        padding:
                            new EdgeInsets.all(getProportionateScreenWidth(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Job ID: ${model.jobs[index].jobId}',
                              style: TextStyle(
                                  fontSize: getProportionateScreenWidth(18), fontWeight: FontWeight.w600,),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )),
              ],
            ),
          ),
        ),
      ),
      viewModelBuilder: () => OptimizedRouteViewModel(),
    );
  }
}
