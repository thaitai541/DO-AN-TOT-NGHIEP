import 'dart:developer';

import 'package:beauty_hub_admin/shared/services/firebase_service.dart';
import 'package:beauty_hub_admin/shared/utils/app_utils.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';

class HomeController extends GetxController {
  RxnBool isStoreExists = RxnBool(null);

  void onCreateStore() {
    AppUtils.showCreateStoreBottomSheet(() {
      checkStoreWithAccountExists();
    });
  }

  void checkStoreWithAccountExists() {
    FirebaseService.fetchBrandWithAccount((value) {
      isStoreExists.value = value;
    }, (error) => log("Error: $error"));
  }

  void onLogOutWithAdmin() {
    FirebaseService.signOut(() {
      Get.offAllNamed(AppRoutes.authPage);
    }, (error) => EasyLoading.showError(error));
  }
}
