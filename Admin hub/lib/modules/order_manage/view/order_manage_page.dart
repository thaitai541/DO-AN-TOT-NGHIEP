import 'package:beauty_hub_admin/modules/order_manage/controller/order_manage_controller.dart';
import 'package:beauty_hub_admin/shared/items/item_order.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderManagePage extends GetView<OrderManageController> {
  const OrderManagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              )),
          title: const Text(
            'Quản lý đơn hàng',
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: const TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              isScrollable: true,
              tabs: [
                Tab(text: 'Tất cả'),
                Tab(text: 'Đang chờ xác nhận'),
                Tab(text: 'Đã xác nhận'),
                Tab(text: 'Đã hủy'),
              ]),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() => controller.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
              child: TabBarView(children: [
                      Obx(() => controller.orders.isNotEmpty
                          ? Expanded(
                              child: ListView.separated(
                                itemBuilder: (context, index) => ItemOrder(
                                  order: controller.orders[index],
                                  onConfirm: (idOrder) {
                                    controller.confirmOrder(idOrder);
                                  },
                                  onCancel: (idOrder) {
                                    controller.cancelOrder(idOrder);
                                  },
                                ),
                                separatorBuilder: (context, index) =>
                                    const Divider(),
                                itemCount: controller.orders.length,
                              ),
                            )
                          : const Center(child: Text('Danh sách trống'))),
                      Obx(() => controller.awaitingOrders.isNotEmpty
                          ? Expanded(
                              child: ListView.separated(
                                itemBuilder: (context, index) => ItemOrder(
                                  order: controller.awaitingOrders[index],
                                  onConfirm: (idOrder) {
                                    controller.confirmOrder(idOrder);
                                  },
                                  onCancel: (idOrder) {
                                    controller.cancelOrder(idOrder);
                                  },
                                ),
                                separatorBuilder: (context, index) =>
                                    const Divider(),
                                itemCount: controller.awaitingOrders.length,
                              ),
                            )
                          : const Center(child: Text('Danh sách trống'))),
                      Obx(() => controller.confirmOrders.isNotEmpty
                          ? Expanded(
                              child: ListView.separated(
                                itemBuilder: (context, index) => ItemOrder(
                                  order: controller.confirmOrders[index],
                                  onConfirm: (idOrder) {},
                                  onCancel: (idOrder) {},
                                ),
                                separatorBuilder: (context, index) =>
                                    const Divider(),
                                itemCount: controller.confirmOrders.length,
                              ),
                            )
                          : const Center(child: Text('Danh sách trống'))),
                      Obx(() => controller.cancelOrders.isNotEmpty
                          ? Expanded(
                              child: ListView.separated(
                                itemBuilder: (context, index) => ItemOrder(
                                  order: controller.cancelOrders[index],
                                  onConfirm: (idOrder) {},
                                  onCancel: (idOrder) {},
                                ),
                                separatorBuilder: (context, index) =>
                                    const Divider(),
                                itemCount: controller.cancelOrders.length,
                              ),
                            )
                          : const Center(child: Text('Danh sách trống'))),
                    ]),
                ))
          ],
        ),
      ),
    );
  }
}
