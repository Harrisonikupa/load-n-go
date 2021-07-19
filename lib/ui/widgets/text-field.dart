import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loadngo/ui/responsiveness/sizing.config.dart';
import 'package:loadngo/ui/styles/colors.dart';

class TextInput extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final Function()? suffixIconPressed;
  final bool? isEnabled;
  final TextEditingController? controller;
  final Widget? prefix;
  final ValueChanged<String>? changed;
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? saved;
  const TextInput({
    Key? key,
    this.hintText,
    this.labelText,
    this.textInputAction,
    this.keyboardType,
    this.suffixIcon,
    this.suffixIconPressed,
    this.controller,
    this.isEnabled,
    this.prefix,
    this.changed,
    this.validator,
    this.saved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SizedBox(
      // height: getProportionateScreenHeight(44),
      child: TextFormField(
        enabled: isEnabled ?? true,
        controller: controller,
        style: TextStyle(color: textBoldFontColor),
        decoration: InputDecoration(
          contentPadding: new EdgeInsets.symmetric(
            vertical: getProportionateScreenHeight(14),
            horizontal: getProportionateScreenWidth(10.0),
          ),
          filled: true,
          fillColor: textFieldBackgroundColor,
          hintText: hintText,
          labelText: labelText,
          labelStyle: TextStyle(color: subtitleGreyColor),
          prefixIcon: prefix,
          suffixIcon: suffixIcon != null
              ? IconButton(
                  icon: suffixIcon!,
                  onPressed: suffixIconPressed,
                )
              : SizedBox(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: textFieldBackgroundColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor, width: 2),
          ),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
            color: textFieldErrorRedColor,
            width: 2,
          )),
          border: OutlineInputBorder(),
        ),
        textInputAction: textInputAction,
        keyboardType: keyboardType,
        onChanged: changed,
        validator: validator,
        onSaved: saved,
      ),
    );
  }
}
