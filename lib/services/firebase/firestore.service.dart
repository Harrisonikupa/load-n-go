import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:loadngo/models/goloop/single-models/job.model.dart';
import 'package:loadngo/models/order-with-location.model.dart';
import 'package:loadngo/models/orders.model.dart';

class FirestoreService {
  final CollectionReference _orderCollectionReference =
      FirebaseFirestore.instance.collection('orders');
  final CollectionReference _jobCollectionReference =
      FirebaseFirestore.instance.collection('job');
  final StreamController<List<Order>> _orderController =
      StreamController<List<Order>>.broadcast();
  final StreamController<List<Job>> _jobController =
      StreamController<List<Job>>.broadcast();
  // Future createOrder(Order order) async {
  //   try {
  //     await _orderCollectionReference
  //         .document(order.id)
  //         .setData(order.toJson());
  //   } catch (e) {
  //     // TODO: Find or create a way to repeat error handling without so much repeated code
  //     if (e is PlatformException) {
  //       return e.message;
  //     }
  //
  //     return e.toString();
  //   }
  // }
  //
  // Future getUser(String uid) async {
  //   try {
  //     var userData = await _orderCollectionReference.document(uid).get();
  //     return Order.fromJson(userData.data);
  //   } catch (e) {
  //     // TODO: Find or create a way to repeat error handling without so much repeated code
  //     if (e is PlatformException) {
  //       return e.message;
  //     }
  //
  //     return e.toString();
  //   }
  // }

  Future addOrder(Order order) async {
    try {
      await _orderCollectionReference.add(order.toJson());
    } catch (e) {
      // TODO: Find or create a way to repeat error handling without so much repeated code
      if (e is PlatformException) {
        return e.message;
      }
      return e.toString();
    }
  }

  Future getOrdersWithoutListeners() async {
    try {
      var orderDocumentSnapshot = await _orderCollectionReference.get();
      if (orderDocumentSnapshot.docs.isNotEmpty) {
        return orderDocumentSnapshot.docs
            .map((snapshot) => OrderWithLocation.fromJson(
                snapshot.data() as Map<String, dynamic>, snapshot.id))
            .where((mappedItem) => mappedItem.orderNumber != null)
            .toList();
      }
    } catch (e) {
      // TODO: Find or create a way to repeat error handling without so much repeated code
      if (e is PlatformException) {
        print(e.message);
        return e.message;
      }
      return e.toString();
    }
  }

  Stream filterListByFieldNames(String areaCode, String pickupDate,
      String deliveryDate, String merchantName) {
    print(merchantName);
    _orderCollectionReference
        // .where('pickupPostalCode', isEqualTo: areaCode)
        .where('pickupDate', isEqualTo: pickupDate)
        // .where('deliveryDate', isEqualTo: deliveryDate)
        // .where('merchantName', isEqualTo: merchantName)
        .snapshots()
        .listen((orderSnapshot) {
      if (orderSnapshot.docs.isNotEmpty) {
        var orders = orderSnapshot.docs
            .map((snapshot) => Order.fromJson(
                snapshot.data() as Map<String, dynamic>, snapshot.id))
            .where((mappedItem) => mappedItem.orderNumber != null)
            .toList();

        _orderController.add(orders);
      }
    });
    return _orderController.stream;
  }

  Stream listenToOrdersRealTime() {
    _orderCollectionReference.snapshots().listen((orderSnapshot) {
      if (orderSnapshot.docs.isNotEmpty) {
        var orders = orderSnapshot.docs
            .map((snapshot) => Order.fromJson(
                snapshot.data() as Map<String, dynamic>, snapshot.id))
            .where((mappedItem) => mappedItem.orderNumber != null)
            .toList();

        _orderController.add(orders);
      }
    });

    return _orderController.stream;
  }

  Future getOrder(Order? order) async {
    try {
      var orderDocumentSnapshot =
          await _orderCollectionReference.doc(order!.documentId).get();

      return orderDocumentSnapshot;
    } catch (e) {
      // TODO: Find or create a way to repeat error handling without so much repeated code
      if (e is PlatformException) {
        print(e.message);
        return e.message;
      }
      return e.toString();
    }
  }

  Stream sortOrderListByFieldName(String fieldName) {
    _orderCollectionReference
        .orderBy(fieldName)
        .snapshots()
        .listen((orderSnapshot) {
      if (orderSnapshot.docs.isNotEmpty) {
        var orders = orderSnapshot.docs
            .map((snapshot) => Order.fromJson(
                snapshot.data() as Map<String, dynamic>, snapshot.id))
            .where((mappedItem) => mappedItem.orderNumber != null)
            .toList();

        _orderController.add(orders);
      }
    });
    return _orderController.stream;
  }

  Future deleteOrder(String documentId) async {
    await _orderCollectionReference.doc(documentId).delete();
  }

  Future updateOrder(Order order) async {
    try {
      print('message33');

      await _orderCollectionReference
          .doc(order.documentId)
          .update(order.toJson());
      print('message44');
    } catch (e) {
      // TODO: Find or create a way to repeat error handling without so much repeated code
      if (e is PlatformException) {
        print('messageqq1');
        print(e.message);
        return e.message;
      }
      return e.toString();
    }
  }

  Future updateApprovalStatus(Order order) async {
    try {
      await _orderCollectionReference
          .doc(order.documentId)
          .update({'approvalStatus': 'Yes'});
    } catch (e) {
      // TODO: Find or create a way to repeat error handling without so much repeated code
      if (e is PlatformException) {
        print(e.message);
        return e.message;
      }
      return e.toString();
    }
  }

  Future addJob(Job job) async {
    try {
      await _jobCollectionReference.add(job.toMap());
    } catch (e) {
      // TODO: Find or create a way to repeat error handling without so much repeated code
      if (e is PlatformException) {
        return e.message;
      }
      return e.toString();
    }
  }

  Future getJob(Job? job) async {
    try {
      var jobDocumentSnapshot =
          await _jobCollectionReference.doc(job!.documentId).get();

      return jobDocumentSnapshot;
    } catch (e) {
      // TODO: Find or create a way to repeat error handling without so much repeated code
      if (e is PlatformException) {
        print(e.message);
        return e.message;
      }
      return e.toString();
    }
  }

  Future getJobsWithoutListeners() async {
    try {
      var jobDocumentSnapshot = await _jobCollectionReference.get();
      if (jobDocumentSnapshot.docs.isNotEmpty) {
        return jobDocumentSnapshot.docs
            .map((snapshot) => Job.fromMap(
                snapshot.data() as Map<String, dynamic>, snapshot.id))
            .where((mappedItem) => mappedItem.jobId != null)
            .toList();
      }
    } catch (e) {
      // TODO: Find or create a way to repeat error handling without so much repeated code
      if (e is PlatformException) {
        print(e.message);
        return e.message;
      }
      return e.toString();
    }
  }

  Stream listenToJobsRealTime() {
    _jobCollectionReference.snapshots().listen((jobSnapshot) {
      if (jobSnapshot.docs.isNotEmpty) {
        var jobs = jobSnapshot.docs
            .map((snapshot) => Job.fromMap(
                snapshot.data() as Map<String, dynamic>, snapshot.id))
            .where((mappedItem) => mappedItem.jobId != null)
            .toList();

        _jobController.add(jobs);
      }
    });

    return _jobController.stream;
  }
}
