import 'package:flutter/cupertino.dart';
import 'package:loadngo/app/app.locator.dart';
import 'package:loadngo/models/orders.model.dart';
import 'package:loadngo/services/firebase/firestore.service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class OrderInformationViewModel extends BaseViewModel {
  final navigationService = locator<NavigationService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final DialogService _dialogService = locator<DialogService>();
  final formKey = GlobalKey<FormState>();

  // Controllers
  var orderNumberController = new TextEditingController();
  var orderDescriptionController = new TextEditingController();
  var firstNameController = new TextEditingController();
  var lastNameController = new TextEditingController();
  var phoneNumberController = new TextEditingController();
  var companyController = new TextEditingController();
  var merchantNameController = new TextEditingController();
  var weightController = new TextEditingController();
  var quantityController = new TextEditingController();
  var pickupDateController = new TextEditingController();
  var pickupAddressController = new TextEditingController();
  var pickupPostalCodeController = new TextEditingController();
  var deliveryDateController = new TextEditingController();
  var deliveryAddressController = new TextEditingController();
  var deliveryPostalCodeController = new TextEditingController();
  Order orderInfo = new Order();
  OrderInformationViewModel(Order? orderInfo) {
    this.orderInfo = orderInfo!;
    orderNumberController.text = orderInfo.orderNumber!;
    orderDescriptionController.text = orderInfo.orderDescription!;
    firstNameController.text = orderInfo.customerFirstName!;
    lastNameController.text = orderInfo.customerLastName!;
    phoneNumberController.text = orderInfo.customerPhoneNumber!;
    companyController.text = orderInfo.customerCompany!;
    merchantNameController.text = orderInfo.merchantName!;
    weightController.text = orderInfo.weightOfOrder!;
    quantityController.text = orderInfo.quantity!.toString();
    pickupDateController.text = orderInfo.pickupDate!;
    pickupAddressController.text = orderInfo.pickupAddress!;
    pickupPostalCodeController.text = orderInfo.pickupPostalCode!;
    deliveryDateController.text = orderInfo.deliveryDate!;
    deliveryAddressController.text = orderInfo.deliveryAddress!;
    deliveryPostalCodeController.text = orderInfo.deliveryPostalCode!;
  }

  void navigateBack() => navigationService.back();

  Future updateApprovalStates() async {
    print(orderInfo);
    var dialogResponse = await _dialogService.showConfirmationDialog(
        title: 'Are you sure?',
        description:
            'Do you really want to update approval the approval status of this order?',
        confirmationTitle: 'Yes',
        cancelTitle: 'No');

    if (dialogResponse!.confirmed) {
      setBusy(true);
      await _firestoreService.updateApprovalStatus(orderInfo);
      orderInfo.approvalStatus = 'Yes';
      notifyListeners();
      setBusy(false);
    }
  }

  Future updateOrder() async {
    orderInfo.orderNumber = orderNumberController.text;
    orderInfo.orderDescription = orderDescriptionController.text;
    orderInfo.customerFirstName = firstNameController.text;
    orderInfo.customerLastName = lastNameController.text;
    orderInfo.customerPhoneNumber = phoneNumberController.text;
    orderInfo.customerCompany = companyController.text;
    orderInfo.merchantName = merchantNameController.text;
    orderInfo.weightOfOrder = weightController.text;
    orderInfo.quantity = int.parse(quantityController.text);
    orderInfo.pickupDate = pickupDateController.text;
    orderInfo.pickupAddress = pickupAddressController.text;
    orderInfo.pickupPostalCode = pickupPostalCodeController.text;
    orderInfo.deliveryDate = deliveryDateController.text;
    orderInfo.deliveryAddress = deliveryAddressController.text;
    orderInfo.deliveryPostalCode = deliveryPostalCodeController.text;

    setBusy(true);
    await _firestoreService.updateOrder(orderInfo);
    var dialogResponse = await _dialogService.showDialog(
        title: 'Update Complete', description: 'Your update was successful');
    if (dialogResponse!.confirmed) {
      notifyListeners();
      navigationService.back();
    }
    setBusy(false);
  }
}
