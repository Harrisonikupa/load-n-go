import 'package:flutter/material.dart';
import 'package:loadngo/ui/responsiveness/sizing.config.dart';

class SubmitButton extends StatelessWidget {
  @required
  final Function()? onSubmit;
  @required
  final String? buttonText;
  @required
  final Color? textColor;
  @required
  final Color? buttonColor;
  @required
  final Color? borderColor;
  final Widget? buttonIcon;
  final EdgeInsets? buttonPadding;
  final EdgeInsets? innerButtonPadding;

  const SubmitButton(
      {Key? key,
      this.onSubmit,
      this.buttonText,
      this.buttonColor,
      this.borderColor,
      this.buttonIcon,
      this.textColor,
      this.buttonPadding,
      this.innerButtonPadding})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return GestureDetector(
      child: Align(
        child: Padding(
          padding: buttonPadding != null
              ? buttonPadding!
              : new EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(40.0)),
          child: Container(
            padding: innerButtonPadding != null
                ? innerButtonPadding
                : EdgeInsets.all(
                    getProportionateScreenWidth(15.0),
                  ),
            // width: double.infinity,
            decoration: BoxDecoration(
              color: buttonColor,
              borderRadius:
                  BorderRadius.circular(getProportionateScreenWidth(10.0)),
              border: Border.all(
                color: borderColor!,
              ),
              // boxShadow: [
              //   kbsMain,
              // ],
            ),
            child: Row(
              mainAxisAlignment: buttonIcon == null
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              children: [
                if (buttonIcon != null) buttonIcon!,
                if (buttonIcon != null)
                  SizedBox(
                    width: getProportionateScreenWidth(5.0),
                  ),
                Text(
                  buttonText!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: textColor,
                    fontSize: getProportionateScreenHeight(
                      16.0,
                    ),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      onTap: onSubmit,
    );
  }
}
