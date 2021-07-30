import 'package:flutter/material.dart';
import 'package:loadngo/ui/responsiveness/sizing.config.dart';
import 'package:loadngo/ui/styles/colors.dart';

class Loader extends StatelessWidget {
  const Loader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: whiteColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: getProportionateScreenWidth(50),
            ),
            SizedBox(
              height: getProportionateScreenHeight(10),
            ),
            SizedBox(
              width: getProportionateScreenWidth(70),
              child: LinearProgressIndicator(
                backgroundColor: primaryColor,
                minHeight: getProportionateScreenWidth(2),
                valueColor: AlwaysStoppedAnimation<Color>(whiteColor),
              ),
            )
          ],
        ),
      ),
    );
  }
}
