import 'package:beauty_hub_admin/modules/home/view/store_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Beauty Hub Admin',
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Obx(() => StoreWidget(
            isExists: controller.isStoreExists.value,
            onLogOut: () {
              controller.onLogOutWithAdmin();
            },
            onCreate: () {
              controller.onCreateStore();
            },
          )),
    );
  }
}
