import 'dart:developer';

import 'package:beauty_hub_admin/models/product.dart';
import 'package:beauty_hub_admin/routes/app_routes.dart';
import 'package:beauty_hub_admin/shared/services/firebase_service.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class ProductManageController extends GetxController {
  RxList<Product> productList = RxList<Product>();
  RxBool isLoading = RxBool(true);

  @override
  void onInit() {
    getProducts();
    super.onInit();
  }

  Future<void> getProducts() async {
    FirebaseService.fetchProducts((dataList) {
      isLoading.value = false;
      productList.value = dataList;
    }, (error) {
      log('Error: $error');
      EasyLoading.showError('Đã có lỗi xảy ra');
    });
  }

  void onAddProduct() {
    Get.toNamed(AppRoutes.addProductPage);
  }

  void onEditProduct(Product product) {
    Get.toNamed(AppRoutes.addProductPage, arguments: product);
  }
}
