import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loadngo/ui/responsiveness/sizing.config.dart';
import 'package:loadngo/ui/styles/colors.dart';

class OrderItem extends StatelessWidget {
  final Function()? tap;
  final String? customerName;
  final String? orderNumber;
  final String? pickupDate;
  final String? pickupLocation;
  final String? deliveryDate;
  final String? deliveryLocation;
  final String? weightOfOrder;
  final String? quantity;
  final Function()? onDelete;
  final Function()? onView;
  final bool? isSelected;

  const OrderItem({
    Key? key,
    this.tap,
    this.customerName,
    this.orderNumber,
    this.pickupDate,
    this.pickupLocation,
    this.deliveryDate,
    this.deliveryLocation,
    this.weightOfOrder,
    this.quantity,
    this.onDelete,
    this.onView,
    this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return GestureDetector(
      onTap: tap,
      child: Container(
        margin: new EdgeInsets.only(
            bottom: getProportionateScreenHeight(
          10.0,
        )),
        width: double.infinity,
        padding: new EdgeInsets.all(
          getProportionateScreenWidth(
            5.0,
          ),
        ),
        decoration: BoxDecoration(
          color: isSelected! ? checkedColor : whiteColor,
          border: Border.all(
            color: isSelected! ? primaryColor : lightGreyColor,
          ),
          borderRadius: BorderRadius.circular(
            getProportionateScreenWidth(
              5.0,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: getProportionateScreenHeight(10.0),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name: $customerName',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Order No: $orderNumber',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: onView,
                      child: SvgPicture.asset(
                        'assets/images/eye.svg',
                        color: primaryColor,
                      ),
                    ),
                    SizedBox(
                      width: getProportionateScreenWidth(10.0),
                    ),
                    GestureDetector(
                      onTap: onDelete,
                      child: SvgPicture.asset(
                        'assets/images/delete.svg',
                        color: redColor,
                      ),
                    )
                  ],
                ),
              ],
            ),
            SizedBox(
              height: getProportionateScreenHeight(10.0),
            ),
            Divider(
              height: getProportionateScreenHeight(1.0),
              color: isSelected! ? primaryColor : lightGreyColor,
              thickness: getProportionateScreenHeight(1.0),
            ),
            SizedBox(
              height: getProportionateScreenHeight(10.0),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.add_location,
                  color: primaryColor,
                ),
                SizedBox(
                  width: getProportionateScreenWidth(5.0),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pickup Date: $pickupDate',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Pickup Location: $pickupLocation',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
              height: getProportionateScreenHeight(10.0),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.add_location_alt,
                  color: primaryColor,
                ),
                SizedBox(
                  width: getProportionateScreenWidth(5.0),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Delivery Date: $deliveryDate',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Delivery Location: $deliveryLocation',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
              height: getProportionateScreenHeight(10.0),
            ),
            Divider(
              height: getProportionateScreenHeight(1.0),
              color: isSelected! ? primaryColor : lightGreyColor,
              thickness: getProportionateScreenHeight(1.0),
            ),
            SizedBox(
              height: getProportionateScreenHeight(10.0),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Weight: $weightOfOrder',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Quantity: $quantity',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
            SizedBox(
              height: getProportionateScreenHeight(5.0),
            ),
          ],
        ),
      ),
    );
  }
}
