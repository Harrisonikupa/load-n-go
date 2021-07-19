class Order {
  Order(
      {this.approvalStatus,
      this.customerCompany,
      this.customerEmail,
      this.customerFirstName,
      this.customerLastName,
      this.customerPhoneNumber,
      this.deliveryAddress,
      this.deliveryAddressTwo,
      this.deliveryDate,
      this.deliveryPostalCode,
      this.merchantName,
      this.orderDescription,
      this.orderNumber,
      this.pickupAddress,
      this.pickupAddressTwo,
      this.pickupDate,
      this.pickupPostalCode,
      this.quantity,
      this.weightOfOrder,
      this.documentId});

  String? approvalStatus;
  String? customerCompany;
  String? customerEmail;
  String? customerFirstName;
  String? customerLastName;
  String? customerPhoneNumber;
  String? deliveryAddress;
  String? deliveryAddressTwo;
  String? deliveryDate;
  String? deliveryPostalCode;
  String? merchantName;
  String? orderDescription;
  String? orderNumber;
  String? pickupAddress;
  String? pickupAddressTwo;
  String? pickupDate;
  String? pickupPostalCode;
  int? quantity;
  String? weightOfOrder;
  String? documentId;

  factory Order.fromJson(Map<String, dynamic> json, String documentId) => Order(
      approvalStatus: json["approvalStatus"],
      customerCompany: json["customerCompany"],
      customerEmail: json["customerEmail"],
      customerFirstName: json["customerFirstName"],
      customerLastName: json["customerLastName"],
      customerPhoneNumber: json["customerPhoneNumber"],
      deliveryAddress: json["deliveryAddress"],
      deliveryAddressTwo: json["deliveryAddressTwo"],
      deliveryDate: json["deliveryDate"],
      deliveryPostalCode: json["deliveryPostalCode"],
      merchantName: json["merchantName"],
      orderDescription: json["orderDescription"],
      orderNumber: json["orderNumber"],
      pickupAddress: json["pickupAddress"],
      pickupAddressTwo: json["pickupAddressTwo"],
      pickupDate: json["pickupDate"],
      pickupPostalCode: json["pickupPostalCode"],
      quantity: json["quantity"],
      weightOfOrder: json["weightOfOrder"],
      documentId: documentId);

  Map<String, dynamic> toJson() => {
        "approvalStatus": approvalStatus,
        "customerCompany": customerCompany,
        "customerEmail": customerEmail,
        "customerFirstName": customerFirstName,
        "customerLastName": customerLastName,
        "customerPhoneNumber": customerPhoneNumber,
        "deliveryAddress": deliveryAddress,
        "deliveryAddressTwo": deliveryAddressTwo,
        "deliveryDate": deliveryDate,
        "deliveryPostalCode": deliveryPostalCode,
        "merchantName": merchantName,
        "orderDescription": orderDescription,
        "orderNumber": orderNumber,
        "pickupAddress": pickupAddress,
        "pickupAddressTwo": pickupAddressTwo,
        "pickupDate": pickupDate,
        "pickupPostalCode": pickupPostalCode,
        "quantity": quantity,
        "weightOfOrder": weightOfOrder,
      };
}
