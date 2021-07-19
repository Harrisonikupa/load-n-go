import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loadngo/ui/responsiveness/sizing.config.dart';
import 'package:loadngo/ui/styles/colors.dart';
import 'package:stacked/stacked.dart';

class HomeViewModel extends IndexTrackingViewModel {
  Widget orderIcon() {
    return Container(
      width: getProportionateScreenWidth(45.0),
      height: getProportionateScreenHeight(45.0),
      padding: EdgeInsets.all(getProportionateScreenWidth(10.0)),
      decoration: BoxDecoration(
          color: currentIndex == 0 ? primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(getProportionateScreenWidth(
            20.0,
          ))),
      child: SvgPicture.asset(
        'assets/images/orders.svg',
        color: currentIndex == 0 ? Colors.white : primaryColor,
      ),
    );
  }

  Widget deliveryIcon() {
    return Container(
      width: getProportionateScreenWidth(45.0),
      height: getProportionateScreenHeight(45.0),
      padding: EdgeInsets.all(getProportionateScreenWidth(10.0)),
      decoration: BoxDecoration(
          color: currentIndex == 1 ? primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(getProportionateScreenWidth(
            20.0,
          ))),
      child: SvgPicture.asset(
        'assets/images/delivery.svg',
        color: currentIndex == 1 ? Colors.white : primaryColor,
      ),
    );
  }
}
