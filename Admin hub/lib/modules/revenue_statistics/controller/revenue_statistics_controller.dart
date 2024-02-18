import 'package:beauty_hub_admin/models/order_item.dart';
import 'package:beauty_hub_admin/shared/services/firebase_service.dart';
import 'package:get/get.dart';

import '../../../models/order.dart';

class RevenueStatisticsController extends GetxController {
  RxDouble revenueStore = RxDouble(0.0);
  RxDouble awaitingRevenueStore = RxDouble(0.0);
  RxDouble confirmRevenueStore = RxDouble(0.0);
  RxList<Order> orderList = RxList<Order>();
  RxList<Order> awaitingOrderList = RxList<Order>();
  RxList<Order> confirmOrderList = RxList<Order>();
  RxList<Order> cancelOrderList = RxList<Order>();

  @override
  void onInit() {
    getRevenueStore();
    super.onInit();
  }

  Future<void> getRevenueStore() async {
    FirebaseService.fetchOrders((dataList) {
      orderList.value = dataList
          .where((item) => item.status == 'CREATED' || item.status == 'SUCCESS')
          .toList();
      awaitingOrderList.value =
          dataList.where((item) => item.status == 'CREATED').toList();
      confirmOrderList.value =
          dataList.where((item) => item.status == 'SUCCESS').toList();
      cancelOrderList.value =
          dataList.where((e) => e.status == 'CANCEL').toList();
      List<OrderItem> orderItems = [];
      List<OrderItem> orderItems1 = [];
      List<OrderItem> orderItems2 = [];
      for (var element in orderList) {
        orderItems.addAll(element.orderItems);
      }
      for (var e in orderItems) {
        revenueStore.value = revenueStore.value + e.pricePerItem * e.quantity;
      }
      for (var element in awaitingOrderList) {
        orderItems1.addAll(element.orderItems);
      }
      for (var e in orderItems1) {
        awaitingRevenueStore.value =
            awaitingRevenueStore.value + e.pricePerItem * e.quantity;
      }
      for (var element in confirmOrderList) {
        orderItems2.addAll(element.orderItems);
      }
      for (var e in orderItems2) {
        confirmRevenueStore.value =
            confirmRevenueStore.value + e.pricePerItem * e.quantity;
      }
    });
  }
}
