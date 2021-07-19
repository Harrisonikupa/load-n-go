import 'package:flutter/cupertino.dart';
import 'package:loadngo/ui/responsiveness/sizing.config.dart';

class SortTablet extends StatelessWidget {
  final Function()? tap;
  final Color? textColor;
  final Color? backgroundColor;
  final Color? borderColor;
  final String? label;

  const SortTablet(
      {Key? key,
      this.tap,
      this.label,
      this.textColor,
      this.backgroundColor,
      this.borderColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return GestureDetector(
        onTap: () => {},
        child: Container(
          margin: new EdgeInsets.only(right: getProportionateScreenWidth(10.0)),
          child: Text(
            '$label',
            style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: getProportionateScreenHeight(
                  14.0,
                )),
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(
              getProportionateScreenHeight(15.0),
            ),
            border: Border.all(
              color: borderColor!,
            ),
          ),
          padding: new EdgeInsets.symmetric(
              vertical: getProportionateScreenHeight(10.0),
              horizontal: getProportionateScreenWidth(10.0)),
        ));
  }
}
