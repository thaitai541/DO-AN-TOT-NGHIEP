import 'package:beauty_hub_admin/shared/widgets/create_store.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AppUtils {
  static String formatPrice(double value) {
    NumberFormat numberFormat = NumberFormat('#,###');
    return numberFormat.format(value);
  }

  static String generateNameAvatar(String fullName) {
    String nameAvatar = '';
    final splitted = fullName.split(' ');
    for (var str in splitted) {
      nameAvatar = nameAvatar + str.substring(0, 1);
    }
    return nameAvatar;
  }

  static String formatOrderStatus(String status) {
    return status == 'CREATED'
        ? 'Đã đặt hàng'
        : status == "SUCCESS"
            ? 'Đã xác nhận'
            : 'Đã huỷ';
  }

  static Color formatOrderStatusColor(String status) {
    return status == 'CREATED'
        ? Colors.black
        : status == 'SUCCESS'
            ? Colors.green
            : Colors.redAccent;
  }

  static void showCreateStoreBottomSheet(Function() onCreate) {
    showModalBottomSheet(
      context: Get.context!,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      builder: (context) => const CreateStore(),
    ).then((value) {
      onCreate();
    });
  }
}
