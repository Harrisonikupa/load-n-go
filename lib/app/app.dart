import 'package:loadngo/services/Thirdparty/grasshopper.service.dart';
import 'package:loadngo/services/firebase/firestore.service.dart';
import 'package:loadngo/ui/views/deliveries/deliveries.view.dart';
import 'package:loadngo/ui/views/dummy/dummy.view.dart';
import 'package:loadngo/ui/views/home/home.view.dart';
import 'package:loadngo/ui/views/order-information/order-information.view.dart';
import 'package:loadngo/ui/views/orders/orders.view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

@StackedApp(routes: [
  MaterialRoute(page: HomeView, initial: true),
  MaterialRoute(page: DeliveriesView),
  MaterialRoute(page: OrdersView),
  MaterialRoute(page: OrderInformationView),
  MaterialRoute(page: DummyView),
], dependencies: [
  LazySingleton(classType: NavigationService),
  LazySingleton(classType: FirestoreService),
  LazySingleton(classType: GrasshopperService),
  LazySingleton(classType: DialogService),
])
class AppSetup {}
