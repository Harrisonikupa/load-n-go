import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loadngo/models/orders.model.dart';
import 'package:loadngo/ui/responsiveness/sizing.config.dart';
import 'package:loadngo/ui/styles/colors.dart';
import 'package:loadngo/ui/styles/styles.dart';
import 'package:loadngo/ui/views/order-information/order-information.model.dart';
import 'package:loadngo/ui/widgets/custom-button.dart';
import 'package:loadngo/ui/widgets/text-field.dart';
import 'package:stacked/stacked.dart';

class OrderInformationView extends StatelessWidget {
  final Order? orderInfo;
  const OrderInformationView({Key? key, this.orderInfo}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return ViewModelBuilder<OrderInformationViewModel>.reactive(
      builder: (context, model, child) => SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: new EdgeInsets.all(
              getProportionateScreenWidth(
                10.0,
              ),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: model.navigateBack,
                        child: Container(
                          padding: new EdgeInsets.all(
                              getProportionateScreenWidth(5.0)),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(
                              getProportionateScreenWidth(10.0),
                            ),
                          ),
                          child: SvgPicture.asset(
                            'assets/images/back.svg',
                            color: whiteColor,
                          ),
                        ),
                      ),
                      Text(
                        'Order Information',
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
                    height: getProportionateScreenHeight(5.0),
                  ),
                  Divider(
                    color: lightGreyColor,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () => showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) =>
                                editOrderInformationBuildSheet(model)),
                        child: Container(
                          width: getProportionateScreenWidth(50.0),
                          padding: new EdgeInsets.all(
                              getProportionateScreenWidth(10.0)),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(
                              getProportionateScreenWidth(10.0),
                            ),
                          ),
                          child: Text(
                            'Edit',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: whiteColor),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: model.updateApprovalStates,
                        child: Container(
                          width: getProportionateScreenWidth(
                            100.0,
                          ),
                          padding: new EdgeInsets.all(
                            getProportionateScreenWidth(
                              10.0,
                            ),
                          ),
                          decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.circular(
                                getProportionateScreenWidth(
                                  10.0,
                                ),
                              ),
                              border: Border.all(
                                color: primaryColor,
                              )),
                          child: Text(
                            'Change Status',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: primaryColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(15.0),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Name', style: labelTextStyle),
                        SizedBox(
                          height: getProportionateScreenHeight(
                            2.0,
                          ),
                        ),
                        Text(
                          '${orderInfo!.customerFirstName} ${orderInfo!.customerLastName}',
                          style: labelValueTextStyle,
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(
                            8.0,
                          ),
                        ),
                        Text('Phone Number', style: labelTextStyle),
                        SizedBox(
                          height: getProportionateScreenHeight(
                            2.0,
                          ),
                        ),
                        Text(
                          '${orderInfo!.customerPhoneNumber}',
                          style: labelValueTextStyle,
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(
                            8.0,
                          ),
                        ),
                        Text('Company', style: labelTextStyle),
                        SizedBox(
                          height: getProportionateScreenHeight(
                            2.0,
                          ),
                        ),
                        Text(
                          '${orderInfo!.customerCompany}',
                          style: labelValueTextStyle,
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(
                            8.0,
                          ),
                        ),
                        Text('Merchant Name', style: labelTextStyle),
                        SizedBox(
                          height: getProportionateScreenHeight(
                            2.0,
                          ),
                        ),
                        Text(
                          '${orderInfo!.merchantName}',
                          style: labelValueTextStyle,
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(
                            8.0,
                          ),
                        ),
                        Text('Approval Status', style: labelTextStyle),
                        SizedBox(
                          height: getProportionateScreenHeight(
                            2.0,
                          ),
                        ),
                        Text(
                          '${orderInfo!.approvalStatus}',
                          style: labelValueTextStyle,
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(
                            8.0,
                          ),
                        ),
                        Divider(
                          color: lightGreyColor,
                        ),
                        Text('Order Number', style: labelTextStyle),
                        SizedBox(
                          height: getProportionateScreenHeight(
                            2.0,
                          ),
                        ),
                        Text(
                          '${orderInfo!.orderNumber}e',
                          style: labelValueTextStyle,
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(
                            8.0,
                          ),
                        ),
                        Text('Order Description', style: labelTextStyle),
                        SizedBox(
                          height: getProportionateScreenHeight(
                            2.0,
                          ),
                        ),
                        Text(
                          '${orderInfo!.orderDescription}',
                          style: labelValueTextStyle,
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(
                            8.0,
                          ),
                        ),
                        Divider(
                          color: lightGreyColor,
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(
                            8.0,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Weight', style: labelTextStyle),
                                SizedBox(
                                  height: getProportionateScreenHeight(
                                    2.0,
                                  ),
                                ),
                                Text(
                                  '${orderInfo!.weightOfOrder}',
                                  style: labelValueTextStyle,
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('Quantity', style: labelTextStyle),
                                SizedBox(
                                  height: getProportionateScreenHeight(
                                    2.0,
                                  ),
                                ),
                                Text(
                                  '${orderInfo!.quantity}',
                                  style: labelValueTextStyle,
                                ),
                              ],
                            ),
                          ],
                        ),
                        Divider(
                          color: lightGreyColor,
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(
                            8.0,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.add_location,
                                  color: primaryColor,
                                ),
                                Text(
                                  'Pickup Information',
                                  style: labelTextStyle,
                                )
                              ],
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(8.0),
                            ),
                            Text('Date', style: labelTextStyle),
                            SizedBox(
                              height: getProportionateScreenHeight(
                                2.0,
                              ),
                            ),
                            Text(
                              '${orderInfo!.pickupDate}',
                              style: labelValueTextStyle,
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(
                                8.0,
                              ),
                            ),
                            Text('Address', style: labelTextStyle),
                            SizedBox(
                              height: getProportionateScreenHeight(
                                2.0,
                              ),
                            ),
                            Text(
                              '${orderInfo!.pickupAddress}',
                              style: labelValueTextStyle,
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(
                                8.0,
                              ),
                            ),
                            Text('Postal Code', style: labelTextStyle),
                            SizedBox(
                              height: getProportionateScreenHeight(
                                2.0,
                              ),
                            ),
                            Text(
                              '${orderInfo!.pickupPostalCode}',
                              style: labelValueTextStyle,
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(
                                8.0,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(
                            8.0,
                          ),
                        ),
                        Divider(
                          color: lightGreyColor,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.add_location_alt,
                                  color: primaryColor,
                                ),
                                Text(
                                  'Delivery Information',
                                  style: labelTextStyle,
                                )
                              ],
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(8.0),
                            ),
                            Text('Date', style: labelTextStyle),
                            SizedBox(
                              height: getProportionateScreenHeight(
                                2.0,
                              ),
                            ),
                            Text(
                              '${orderInfo!.deliveryDate}',
                              style: labelValueTextStyle,
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(
                                8.0,
                              ),
                            ),
                            Text('Address', style: labelTextStyle),
                            SizedBox(
                              height: getProportionateScreenHeight(
                                2.0,
                              ),
                            ),
                            Text(
                              '${orderInfo!.deliveryAddress}',
                              style: labelValueTextStyle,
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(
                                8.0,
                              ),
                            ),
                            Text('Postal Code', style: labelTextStyle),
                            SizedBox(
                              height: getProportionateScreenHeight(
                                2.0,
                              ),
                            ),
                            Text(
                              '${orderInfo!.deliveryPostalCode}',
                              style: labelValueTextStyle,
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(
                                8.0,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(
                            8.0,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      viewModelBuilder: () => OrderInformationViewModel(orderInfo!),
    );
  }

  Widget makeDismissible(
          {required Widget child, OrderInformationViewModel? model}) =>
      GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: model!.navigateBack,
        child: GestureDetector(
          onTap: () {},
          child: child,
        ),
      );
  Widget editOrderInformationBuildSheet(OrderInformationViewModel model) =>
      makeDismissible(
          child: DraggableScrollableSheet(
            initialChildSize: 0.8,
            maxChildSize: 0.8,
            minChildSize: 0.6,
            builder: (_, controller) => Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(
                      getProportionateScreenWidth(16),
                    ),
                  ),
                ),
                // padding: new EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: getProportionateScreenHeight(50),
                      child: Container(
                        padding: new EdgeInsets.symmetric(
                            horizontal: getProportionateScreenWidth(10)),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(
                              getProportionateScreenWidth(16),
                            ),
                          ),
                          color: primaryColor,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Update Order Information',
                              style: TextStyle(
                                  fontSize: getProportionateScreenWidth(16.0),
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white),
                            ),
                            IconButton(
                                onPressed: model.navigateBack,
                                icon: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: getProportionateScreenWidth(24),
                                ))
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: new EdgeInsets.all(
                          getProportionateScreenWidth(10),
                        ),
                        child: SingleChildScrollView(
                          child: Form(
                            key: model.formKey,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: getProportionateScreenHeight(20.0),
                                ),
                                TextInput(
                                  labelText: 'Order Number',
                                  controller: model.orderNumberController,
                                ),
                                SizedBox(
                                  height: getProportionateScreenHeight(
                                    20.0,
                                  ),
                                ),
                                TextInput(
                                  labelText: 'Order Description',
                                  controller: model.orderDescriptionController,
                                ),
                                SizedBox(
                                  height: getProportionateScreenHeight(
                                    20.0,
                                  ),
                                ),
                                TextInput(
                                  labelText: 'Customer First Name',
                                  controller: model.firstNameController,
                                ),
                                SizedBox(
                                  height: getProportionateScreenHeight(
                                    20.0,
                                  ),
                                ),
                                TextInput(
                                  labelText: 'Customer Last Name',
                                  controller: model.lastNameController,
                                ),
                                SizedBox(
                                  height: getProportionateScreenHeight(
                                    20.0,
                                  ),
                                ),
                                TextInput(
                                  labelText: 'Customer Phone Number',
                                  controller: model.phoneNumberController,
                                ),
                                SizedBox(
                                  height: getProportionateScreenHeight(
                                    20.0,
                                  ),
                                ),
                                TextInput(
                                  labelText: 'Customer Company',
                                  controller: model.companyController,
                                ),
                                SizedBox(
                                  height: getProportionateScreenHeight(
                                    20.0,
                                  ),
                                ),
                                TextInput(
                                  labelText: 'Pickup Date',
                                  controller: model.pickupDateController,
                                ),
                                SizedBox(
                                  height: getProportionateScreenHeight(
                                    20.0,
                                  ),
                                ),
                                TextInput(
                                  labelText: 'Pickup Address',
                                  controller: model.pickupAddressController,
                                ),
                                SizedBox(
                                  height: getProportionateScreenHeight(
                                    20.0,
                                  ),
                                ),
                                TextInput(
                                  labelText: 'Pickup Postal Code',
                                  controller: model.pickupPostalCodeController,
                                ),
                                SizedBox(
                                  height: getProportionateScreenHeight(
                                    20.0,
                                  ),
                                ),
                                TextInput(
                                  labelText: 'Delivery Date',
                                  controller: model.deliveryDateController,
                                ),
                                SizedBox(
                                  height: getProportionateScreenHeight(
                                    20.0,
                                  ),
                                ),
                                TextInput(
                                  labelText: 'Delivery Address',
                                  controller: model.deliveryAddressController,
                                ),
                                SizedBox(
                                  height: getProportionateScreenHeight(
                                    20.0,
                                  ),
                                ),
                                TextInput(
                                  labelText: 'Delivery Postal Code',
                                  controller:
                                      model.deliveryPostalCodeController,
                                ),
                                SizedBox(
                                  height: getProportionateScreenHeight(
                                    20.0,
                                  ),
                                ),
                                TextInput(
                                  labelText: 'Weight',
                                  controller: model.weightController,
                                ),
                                SizedBox(
                                  height: getProportionateScreenHeight(
                                    20.0,
                                  ),
                                ),
                                TextInput(
                                  labelText: 'Quantity',
                                  controller: model.quantityController,
                                  keyboardType: TextInputType.number,
                                ),
                                SizedBox(
                                  height: getProportionateScreenHeight(
                                    20.0,
                                  ),
                                ),
                                TextInput(
                                  labelText: 'Merchant Name',
                                  controller: model.merchantNameController,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      flex: 12,
                    ),
                    Expanded(
                      flex: 2,
                      child: SubmitButton(
                        onSubmit: () => model.updateOrder(),
                        borderColor: primaryColor,
                        buttonColor: primaryColor,
                        buttonText: 'Update Order',
                        textColor: Colors.white,
                      ),
                    )
                  ],
                )),
          ),
          model: model);
}
