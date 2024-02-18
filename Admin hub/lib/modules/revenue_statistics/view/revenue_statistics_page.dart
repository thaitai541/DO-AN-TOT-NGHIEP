import 'package:beauty_hub_admin/modules/revenue_statistics/controller/revenue_statistics_controller.dart';
import 'package:beauty_hub_admin/shared/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

part 'revenue_statistic_extension.dart';

class RevenueStatisticsPage extends GetView<RevenueStatisticsController> {
  const RevenueStatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(
            () => controller.revenueStore.value != 0.0
                ? _buildRevenue()
                : const Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
    );
  }
}
