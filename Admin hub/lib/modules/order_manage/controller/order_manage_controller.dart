import 'dart:developer';

import 'package:beauty_hub_admin/models/order.dart';
import 'package:beauty_hub_admin/shared/services/firebase_service.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class OrderManageController extends GetxController {
  RxList<Order> orders = RxList<Order>();
  RxList<Order> awaitingOrders = RxList<Order>();
  RxList<Order> confirmOrders = RxList<Order>();
  RxList<Order> cancelOrders = RxList<Order>();
  RxBool isLoading = RxBool(true);

  @override
  void onInit() {
    getOrders();
    super.onInit();
  }

  @override
  void onReady() {
    getOrders();
    super.onReady();
  }

  Future<void> getOrders() async {
    FirebaseService.fetchOrders((dataList) {
      isLoading.value = false;
      orders.value = dataList;
      awaitingOrders.value =
          dataList.where((e) => e.status == 'CREATED').toList();
      confirmOrders.value = dataList.where((e) => e.status == 'SUCCESS').toList();
      cancelOrders.value = dataList.where((e) => e.status == 'CANCEL').toList();
    });
  }

  Future<void> confirmOrder(String id) async {
    awaitingOrders.removeWhere((e) => e.idOrder == id);
    Order itemOrder = orders.where((i) => i.idOrder == id).first;
    confirmOrders.add(itemOrder);
    FirebaseService.confirmOrder(id, (error) => log('Error: $error'));
    EasyLoading.showSuccess('Đã xác nhận đơn hàng');
  }

  Future<void> cancelOrder(String id) async {
    awaitingOrders.removeWhere((e) => e.idOrder == id);
    Order itemOrder = orders.where((i) => i.idOrder == id).first;
    cancelOrders.add(itemOrder);
    FirebaseService.cancelOrder(id, (error) => log('Error: $error'));
    EasyLoading.showSuccess('Đã hủy đơn hàng này');
  }
}
