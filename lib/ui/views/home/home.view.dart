import 'package:flutter/material.dart';
import 'package:loadngo/ui/responsiveness/sizing.config.dart';
import 'package:loadngo/ui/styles/colors.dart';
import 'package:loadngo/ui/views/deliveries/deliveries.view.dart';
import 'package:loadngo/ui/views/home/home.model.dart';
import 'package:loadngo/ui/views/orders/orders.view.dart';
import 'package:stacked/stacked.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return ViewModelBuilder<HomeViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        backgroundColor: whiteColor,
        body: getViewForIndex(model.currentIndex),
        extendBody: true,
        bottomNavigationBar: Container(
          padding: EdgeInsets.all(getProportionateScreenWidth(5.0)),
          height: getProportionateScreenHeight(80.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(color: whiteColor, boxShadow: [
            BoxShadow(
                offset: Offset(0, 3),
                color: Color(0xFF35B8BE),
                blurRadius: 20.0)
          ]),
          child: BottomNavigationBar(
            // showSelectedLabels: false,
            // showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
            elevation: 0.0,
            currentIndex: model.currentIndex,
            backgroundColor: Colors.transparent,
            selectedItemColor: primaryColor,
            unselectedItemColor: subtitleGreyColor,
            onTap: model.setIndex,
            items: [
              BottomNavigationBarItem(
                label: 'Orders',
                icon: model.orderIcon(),
              ),
              BottomNavigationBarItem(
                label: 'Deliveries',
                icon: model.deliveryIcon(),
              ),
            ],
          ),
        ),
      ),
      viewModelBuilder: () => HomeViewModel(),
    );
  }

  Widget getViewForIndex(int index) {
    switch (index) {
      case 0:
        return OrdersView();
      case 1:
        return DeliveriesView();
      default:
        return OrdersView();
    }
  }
}
