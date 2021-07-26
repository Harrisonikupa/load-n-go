import 'dart:io';

import 'package:csv/csv.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:loadngo/app/app.locator.dart';
import 'package:loadngo/app/app.router.dart';
import 'package:loadngo/models/orders.model.dart';
import 'package:loadngo/services/firebase/firestore.service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class OrdersViewModel extends BaseViewModel {
  final navigationService = locator<NavigationService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final DialogService _dialogService = locator<DialogService>();
  void navigateBack() => navigationService.back();
  void navigateToOrderInformationView() =>
      navigationService.navigateTo(Routes.orderInformationView);

  //Controllers
  final areaCodeController = new TextEditingController();
  final pickupDateController = new TextEditingController();
  final deliveryDateController = new TextEditingController();
  final merchantNameController = new TextEditingController();

  final bool isMultiSelection = true;
  bool hasSelectedAll = false;
  List<Order> selectedOrders = [];

  List<Order> _orders = [];
  List<Order> get orders => _orders;
  Order newOrder = new Order();
  int sortingBy = -1;

  List<Order> _allOrders = [];

  bool checkValue = false;
  selectSortingType(int type) {
    sortingBy = type;
    // notifyListeners();
  }

  updateCheckboxValue(value) {
    checkValue = value;
    notifyListeners();
    print(value);
  }

  //Add an order
  Future addOrder() async {
    setBusy(true);
    newOrder.orderNumber = 'N12345679';
    newOrder.orderDescription = '1 Carton of water';
    newOrder.weightOfOrder = '50g';
    newOrder.quantity = 11;
    newOrder.pickupDate = '2021-01-11';
    newOrder.pickupAddress = '123 Raffles Place';
    newOrder.pickupPostalCode = '101111';
    newOrder.deliveryDate = '2021-01-11';
    newOrder.deliveryAddress = '123 City Hall';
    newOrder.deliveryPostalCode = '546090';
    newOrder.customerFirstName = 'Jamie';
    newOrder.customerLastName = 'Vardy';
    newOrder.customerEmail = 'jamievardy@gmail.com';
    newOrder.customerPhoneNumber = '122232390';
    newOrder.customerCompany = 'Company 2';
    newOrder.merchantName = 'Merchant 2';
    newOrder.approvalStatus = 'NO';

    // Todo: Can include other parameters later
    var result = await _firestoreService.addOrder(newOrder);

    setBusy(false);

    if (result is String) {
      await _dialogService.showDialog(
          title: 'Could not create order', description: result);
    } else {
      await _dialogService.showDialog(
          title: 'Order created successfully',
          description: 'Your order was added');
    }
  }

  void listenToOrders() {
    setBusy(true);
    _firestoreService.listenToOrdersRealTime().listen((ordersData) {
      List<Order> updatedOrders = ordersData;
      if (ordersData != null && updatedOrders.length > 0) {
        _orders = updatedOrders;
        _allOrders = updatedOrders;
        notifyListeners();
      }
      setBusy(false);
    });
  }

  // void listenToSortedOrders(fieldName) {
  //   setBusy(true);
  //   _firestoreService.sortOrderListByFieldName(fieldName).listen((ordersData) {
  //     List<Order> updatedOrders = ordersData;
  //     if (ordersData != null && updatedOrders.length > 0) {
  //       _orders = updatedOrders;
  //       notifyListeners();
  //     }
  //     setBusy(false);
  //   });
  // }
  //
  // void listenToFilterOrders() {
  //   print('listening has started');
  //   setBusy(true);
  //   _firestoreService
  //       .filterListByFieldNames(
  //           areaCodeController.text,
  //           pickupDateController.text,
  //           deliveryDateController.text,
  //           merchantNameController.text)
  //       .listen((ordersData) {
  //     List<Order> updatedOrders = ordersData;
  //     if (ordersData != null && updatedOrders.length > 0) {
  //       _orders = updatedOrders;
  //       notifyListeners();
  //     }
  //     setBusy(false);
  //   });
  // }

  Future deleteOrder(int index) async {
    var dialogResponse = await _dialogService.showConfirmationDialog(
      title: 'Are you sure?',
      description: 'Do you really want to delete this order?',
      confirmationTitle: 'Yes',
      cancelTitle: 'No',
    );

    if (dialogResponse!.confirmed) {
      setBusy(true);
      await _firestoreService.deleteOrder(_orders[index].documentId!);
      setBusy(false);
    }
  }

  Future deleteOrders() async {
    var dialogResponse = await _dialogService.showConfirmationDialog(
        title: 'Are you sure?',
        description: 'Do you really want to delete these orders?',
        confirmationTitle: 'Yes',
        cancelTitle: 'No');

    if (dialogResponse!.confirmed) {
      setBusy(true);
      selectedOrders.forEach((order) async {
        await _firestoreService.deleteOrder(order.documentId!);
      });
      selectedOrders.clear();
      setBusy(false);
    }
  }

  Future updateApprovalStates() async {
    var dialogResponse = await _dialogService.showConfirmationDialog(
        title: 'Are you sure?',
        description:
            'Do you really want to update approval the approval statuses of these orders?',
        confirmationTitle: 'Yes',
        cancelTitle: 'No');

    if (dialogResponse!.confirmed) {
      setBusy(true);
      selectedOrders.forEach((order) async {
        await _firestoreService.updateApprovalStatus(order);
      });
      selectedOrders.clear();
      setBusy(false);
    }
  }

  void getOrder(int index) {
    navigationService.navigateTo(Routes.orderInformationView,
        arguments: OrderInformationViewArguments(orderInfo: orders[index]));
  }

  void selectOrders(Order order) {
    if (isMultiSelection) {
      final isSelected = selectedOrders.contains(order);
      isSelected ? selectedOrders.remove(order) : selectedOrders.add(order);
    }
    notifyListeners();
  }

  sortOrder(String order) {
    // First code is ascending order
    // Second code is descending order
    if (order == 'areaCode') {
      _orders
          .sort((a, b) => a.pickupPostalCode!.compareTo(b.pickupPostalCode!));
      // _orders
      //     .sort((a, b) => b.pickupPostalCode!.compareTo(a.pickupPostalCode!));
    } else if (order == 'pickupDate') {
      _orders.sort((a, b) => a.pickupDate!.compareTo(b.pickupDate!));
      // _orders.sort((a, b) => b.pickupDate!.compareTo(a.pickupDate!));
    } else if (order == 'deliveryDate') {
      _orders.sort((a, b) => a.deliveryDate!.compareTo(b.deliveryDate!));
      // _orders.sort((a, b) => b.deliveryDate!.compareTo(a.deliveryDate!));
    } else if (order == 'merchantName') {
      _orders.sort((a, b) => a.merchantName!.compareTo(b.merchantName!));
      // _orders.sort((a, b) => b.merchantName!.compareTo(a.merchantName!));
    }
    navigateBack();
    notifyListeners();
  }

  void searchOrders(String keyword) {
    List<Order> result = [];
    if (keyword.isEmpty) {
      result = _allOrders;
    } else {
      result = _allOrders
          .where((order) =>
              order.orderNumber!.contains(keyword) ||
              order.merchantName!.contains(keyword) ||
              order.pickupDate!.contains(keyword) ||
              order.deliveryDate!.contains(keyword))
          .toList();
    }
    _orders = result;
    notifyListeners();
  }

  void advancedSearch() {
    String areaCode = areaCodeController.text;
    String pickupDate = pickupDateController.text;
    String deliveryDate = deliveryDateController.text;
    String merchantName = merchantNameController.text;

    List<Order> result = [];

    result = _allOrders
        .where((order) =>
            order.pickupPostalCode!.contains(areaCode) &&
            order.merchantName!.contains(merchantName) &&
            order.pickupDate!.contains(pickupDate) &&
            order.deliveryDate!.contains(deliveryDate))
        .toList();

    _orders = result;
    navigationService.back();
    notifyListeners();
  }

  void selectAllOrders() {
    if (hasSelectedAll == false) {
      selectedOrders = [...orders];
      hasSelectedAll = true;
    } else {
      selectedOrders.clear();
      hasSelectedAll = false;
    }
    notifyListeners();
  }

  void resetSearch() {
    areaCodeController.clear();
    pickupDateController.clear();
    deliveryDateController.clear();
    merchantNameController.clear();

    listenToOrders();
    navigationService.back();
  }

  void convertOrdersToCSV() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();
    List<List<dynamic>> rows = [];
    List<dynamic> row = [];
    row.add('Order Number');
    row.add('Order Description');
    row.add('Weight Of Order');
    row.add('Quantity');
    row.add('Pickup Date');
    row.add('Pickup Address');
    row.add('Pickup Address Two');
    row.add('Pickup Postal Code');
    row.add('Delivery Date');
    row.add('Delivery Address');
    row.add('Delivery Address Two');
    row.add('Delivery Postal Code');
    row.add('Customer First Name');
    row.add('Customer Last Name');
    row.add('Customer Email');
    row.add('Customer Phone Number');
    row.add('Customer Company');
    row.add('Merchant Name');
    row.add('Approval Status');
    rows.add(row);

    for (int i = 0; i < selectedOrders.length; i++) {
      List<dynamic> row = [];
      row.add(selectedOrders[i].orderNumber);
      row.add(selectedOrders[i].orderDescription);
      row.add(selectedOrders[i].weightOfOrder);
      row.add(selectedOrders[i].quantity);
      row.add(selectedOrders[i].pickupDate);
      row.add(selectedOrders[i].pickupAddress);
      row.add('');
      row.add(selectedOrders[i].pickupPostalCode);
      row.add(selectedOrders[i].deliveryDate);
      row.add(selectedOrders[i].deliveryAddress);
      row.add('');
      row.add(selectedOrders[i].deliveryPostalCode);
      row.add(selectedOrders[i].customerFirstName);
      row.add(selectedOrders[i].customerLastName);
      row.add(selectedOrders[i].customerEmail);
      row.add(selectedOrders[i].customerPhoneNumber);
      row.add(selectedOrders[i].customerCompany);
      row.add(selectedOrders[i].merchantName);
      row.add(selectedOrders[i].approvalStatus);
      rows.add(row);
    }

    String csv = const ListToCsvConverter().convert(rows);

    String dir = await ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_DOWNLOADS);

    String file = '$dir';

    File f = new File(file + '/order-list.csv');

    f.writeAsString(csv);

    var dialogResponse = await _dialogService.showDialog(
        title: 'File exported successfully',
        description:
            'CSV File exported successfully. Please check your downloads folder.');
    if (dialogResponse!.confirmed) {
      selectedOrders.clear();
      notifyListeners();
    }
  }
}
