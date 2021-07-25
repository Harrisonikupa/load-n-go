// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../models/orders.model.dart';
import '../ui/views/deliveries/deliveries.view.dart';
import '../ui/views/home/home.view.dart';
import '../ui/views/optimized-route-view/optimized-route.view.dart';
import '../ui/views/order-information/order-information.view.dart';
import '../ui/views/orders/orders.view.dart';

class Routes {
  static const String homeView = '/';
  static const String deliveriesView = '/deliveries-view';
  static const String ordersView = '/orders-view';
  static const String orderInformationView = '/order-information-view';
  static const String optimizedRouteView = '/optimized-route-view';
  static const all = <String>{
    homeView,
    deliveriesView,
    ordersView,
    orderInformationView,
    optimizedRouteView,
  };
}

class StackedRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.homeView, page: HomeView),
    RouteDef(Routes.deliveriesView, page: DeliveriesView),
    RouteDef(Routes.ordersView, page: OrdersView),
    RouteDef(Routes.orderInformationView, page: OrderInformationView),
    RouteDef(Routes.optimizedRouteView, page: OptimizedRouteView),
  ];
  @override
  Map<Type, StackedRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, StackedRouteFactory>{
    HomeView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const HomeView(),
        settings: data,
      );
    },
    DeliveriesView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const DeliveriesView(),
        settings: data,
      );
    },
    OrdersView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const OrdersView(),
        settings: data,
      );
    },
    OrderInformationView: (data) {
      var args = data.getArgs<OrderInformationViewArguments>(
        orElse: () => OrderInformationViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => OrderInformationView(
          key: args.key,
          orderInfo: args.orderInfo,
        ),
        settings: data,
      );
    },
    OptimizedRouteView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const OptimizedRouteView(),
        settings: data,
      );
    },
  };
}

/// ************************************************************************
/// Arguments holder classes
/// *************************************************************************

/// OrderInformationView arguments holder class
class OrderInformationViewArguments {
  final Key? key;
  final Order? orderInfo;
  OrderInformationViewArguments({this.key, this.orderInfo});
}
