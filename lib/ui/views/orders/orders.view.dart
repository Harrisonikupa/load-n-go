import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loadngo/ui/responsiveness/sizing.config.dart';
import 'package:loadngo/ui/styles/colors.dart';
import 'package:loadngo/ui/views/orders/orders.model.dart';
import 'package:loadngo/ui/widgets/custom-button.dart';
import 'package:loadngo/ui/widgets/order-item.dart';
import 'package:loadngo/ui/widgets/text-field.dart';
import 'package:stacked/stacked.dart';

class OrdersView extends StatelessWidget {
  const OrdersView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return ViewModelBuilder<OrdersViewModel>.reactive(
      onModelReady: (model) => model.listenToOrders(),
      builder: (context, model, child) => SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
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
                      'All Orders',
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .92,
                      child: TextInput(
                        hintText: 'Search Order',
                        labelText: 'Search Order',
                        changed: (value) => model.searchOrders(value),
                        prefix: Icon(
                          Icons.search,
                          color: primaryColor,
                        ),
                        // prefixIcon: Padding(
                        //   padding: const EdgeInsets.all(
                        //     10.0,
                        //   ),
                        //   child: SvgPicture.asset(
                        //     'assets/images/search.svg',
                        //     color: darkGreyColor,
                        //   ),
                        // ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: getProportionateScreenHeight(10.0),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => sortBuildSheet(model)),
                      child: Container(
                        padding: new EdgeInsets.symmetric(
                            vertical: getProportionateScreenHeight(10.0),
                            horizontal: getProportionateScreenWidth(15.0)),
                        decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(
                              getProportionateScreenWidth(10.0),
                            ),
                            border: Border.all(color: primaryColor)),
                        child: Text(
                          'Sort ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: getProportionateScreenHeight(14.0),
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => buildSheet(model)),
                      child: Container(
                        padding: new EdgeInsets.symmetric(
                            vertical: getProportionateScreenHeight(10.0),
                            horizontal: getProportionateScreenWidth(15.0)),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(
                            getProportionateScreenWidth(10.0),
                          ),
                          // border: Border()
                        ),
                        child: Text(
                          'Filter',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: getProportionateScreenHeight(14.0),
                            color: whiteColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: getProportionateScreenHeight(
                    10.0,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => model.addOrder(),
                      child: Container(
                        padding: new EdgeInsets.symmetric(
                            vertical: getProportionateScreenHeight(10.0),
                            horizontal: getProportionateScreenWidth(15.0)),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(
                            getProportionateScreenWidth(10.0),
                          ),
                          // border: Border()
                        ),
                        child: Text(
                          'Add Order',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: getProportionateScreenHeight(14.0),
                            color: whiteColor,
                          ),
                        ),
                      ),
                    ),
                    model.selectedOrders.length > 0
                        ? SizedBox(
                            width: getProportionateScreenWidth(120.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: model.updateApprovalStates,
                                  child: SvgPicture.asset(
                                    'assets/images/edit.svg',
                                    color: primaryColor,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: model.convertOrdersToCSV,
                                  child: SvgPicture.asset(
                                      'assets/images/download.svg',
                                      color: blueColor),
                                ),
                                GestureDetector(
                                  onTap: model.deleteOrders,
                                  child: SvgPicture.asset(
                                    'assets/images/delete.svg',
                                    color: redColor,
                                  ),
                                )
                              ],
                            ),
                          )
                        : Container(),
                    GestureDetector(
                      onTap: () => model.selectAllOrders(),
                      child: Container(
                        padding: new EdgeInsets.symmetric(
                            vertical: getProportionateScreenHeight(10.0),
                            horizontal: getProportionateScreenWidth(15.0)),
                        decoration: BoxDecoration(
                          color: lightPrimaryColor,
                          borderRadius: BorderRadius.circular(
                            getProportionateScreenWidth(10.0),
                          ),
                          // border: Border()
                        ),
                        child: Text(
                          '${model.hasSelectedAll ? 'Deselect All' : 'Select All'}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: getProportionateScreenHeight(14.0),
                            color: whiteColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: getProportionateScreenHeight(10.0),
                ),
                Expanded(
                  child: model.orders.length > 0
                      ? ListView.builder(
                          itemCount: model.orders.length,
                          itemBuilder: (context, index) => OrderItem(
                            tap: () => model.selectOrders(model.orders[index]),
                            customerName:
                                '${model.orders[index].customerFirstName} ${model.orders[index].customerLastName}',
                            orderNumber: model.orders[index].orderNumber,
                            pickupDate: model.orders[index].pickupDate,
                            pickupLocation: model.orders[index].pickupAddress,
                            deliveryDate: model.orders[index].deliveryDate,
                            deliveryLocation:
                                model.orders[index].deliveryAddress,
                            weightOfOrder: model.orders[index].weightOfOrder,
                            quantity: model.orders[index].quantity.toString(),
                            onDelete: () => model.deleteOrder(index),
                            onView: () => model.getOrder(index),
                            isSelected: model.selectedOrders
                                .contains(model.orders[index]),
                          ),
                        )
                      : Text(
                          'No Order Available',
                          style: TextStyle(
                              color: blackColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
      viewModelBuilder: () => OrdersViewModel(),
    );
  }

  Widget makeDismissible({required Widget child, OrdersViewModel? model}) =>
      GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: model!.navigateBack,
        child: GestureDetector(
          onTap: () {},
          child: child,
        ),
      );
  Widget buildSheet(OrdersViewModel model) => makeDismissible(
      child: DraggableScrollableSheet(
        initialChildSize: 0.9,
        // maxChildSize: 0.8,
        // minChildSize: 0.3,
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
                          'Search Filter',
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
                      child: Column(
                        children: [
                          TextInput(
                            hintText: 'Area Code',
                            labelText: 'Area Code',
                            controller: model.areaCodeController,
                            keyboardType: TextInputType.text,

                            // saved: ,
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(15.0),
                          ),
                          TextInput(
                            hintText: 'Pickup Date',
                            labelText: 'Pickup Date',
                            controller: model.pickupDateController,
                            keyboardType: TextInputType.datetime,

                            // saved: ,
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(15.0),
                          ),
                          TextInput(
                            hintText: 'Delivery Date',
                            labelText: 'Delivery Date',
                            controller: model.deliveryDateController,
                            keyboardType: TextInputType.datetime,

                            // saved: ,
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(15.0),
                          ),
                          TextInput(
                            hintText: 'Merchant Name',
                            labelText: 'Merchant Name',
                            controller: model.merchantNameController,
                            keyboardType: TextInputType.text,

                            // saved: ,
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(
                              15.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  flex: 12,
                ),
                Expanded(
                  flex: 2,
                  child: SubmitButton(
                    textColor: Colors.white,
                    borderColor: primaryColor,
                    buttonColor: primaryColor,
                    onSubmit: () => model.advancedSearch(),
                    buttonText: 'Search',
                  ),
                )
              ],
            )),
      ),
      model: model);

  Widget sortBuildSheet(OrdersViewModel model) => makeDismissible(
      child: DraggableScrollableSheet(
        initialChildSize: 0.3,
        maxChildSize: 0.3,
        minChildSize: 0.2,
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
                          'Please choose a sort option',
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
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => model.sortOrder('pickupPostalCode'),
                            child: Container(
                              margin: new EdgeInsets.only(
                                  right: getProportionateScreenWidth(10.0)),
                              padding: new EdgeInsets.symmetric(
                                  vertical: getProportionateScreenHeight(10.0),
                                  horizontal:
                                      getProportionateScreenWidth(15.0)),
                              decoration: BoxDecoration(
                                  color: whiteColor,
                                  borderRadius: BorderRadius.circular(
                                    getProportionateScreenWidth(10.0),
                                  ),
                                  border: Border.all(color: primaryColor)),
                              child: Text(
                                'Area Code ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: getProportionateScreenHeight(14.0),
                                  color: primaryColor,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => model.sortOrder('pickupDate'),
                            child: Container(
                              margin: new EdgeInsets.only(
                                  right: getProportionateScreenWidth(10.0)),
                              padding: new EdgeInsets.symmetric(
                                  vertical: getProportionateScreenHeight(10.0),
                                  horizontal:
                                      getProportionateScreenWidth(15.0)),
                              decoration: BoxDecoration(
                                  color: whiteColor,
                                  borderRadius: BorderRadius.circular(
                                    getProportionateScreenWidth(10.0),
                                  ),
                                  border: Border.all(color: primaryColor)),
                              child: Text(
                                'Pickup Date ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: getProportionateScreenHeight(14.0),
                                  color: primaryColor,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => model.sortOrder('deliveryDate'),
                            child: Container(
                              margin: new EdgeInsets.only(
                                  right: getProportionateScreenWidth(10.0)),
                              padding: new EdgeInsets.symmetric(
                                  vertical: getProportionateScreenHeight(10.0),
                                  horizontal:
                                      getProportionateScreenWidth(15.0)),
                              decoration: BoxDecoration(
                                  color: whiteColor,
                                  borderRadius: BorderRadius.circular(
                                    getProportionateScreenWidth(10.0),
                                  ),
                                  border: Border.all(color: primaryColor)),
                              child: Text(
                                'Delivery Date ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: getProportionateScreenHeight(14.0),
                                  color: primaryColor,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => model.sortOrder('merchantName'),
                            child: Container(
                              margin: new EdgeInsets.only(
                                  right: getProportionateScreenWidth(10.0)),
                              padding: new EdgeInsets.symmetric(
                                  vertical: getProportionateScreenHeight(10.0),
                                  horizontal:
                                      getProportionateScreenWidth(15.0)),
                              decoration: BoxDecoration(
                                  color: whiteColor,
                                  borderRadius: BorderRadius.circular(
                                    getProportionateScreenWidth(10.0),
                                  ),
                                  border: Border.all(color: primaryColor)),
                              child: Text(
                                'Merchant Name ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: getProportionateScreenHeight(14.0),
                                  color: primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  flex: 12,
                ),
                Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: model.navigateBack,
                      child: Text(
                        'Close',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: getProportionateScreenHeight(16.0),
                          color: primaryColor,
                        ),
                      ),
                    ))
              ],
            )),
      ),
      model: model);
}
