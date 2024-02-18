import 'dart:developer';
import 'dart:io';

import 'package:beauty_hub_admin/models/product.dart';
import 'package:beauty_hub_admin/models/product_detail.dart';
import 'package:beauty_hub_admin/modules/product_manage/controller/product_manage_controller.dart';
import 'package:beauty_hub_admin/shared/services/firebase_service.dart';
import 'package:beauty_hub_admin/shared/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../../models/category.dart';

class AddProductController extends GetxController {
  final product = Get.arguments as Product?;

  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController introController = TextEditingController();
  TextEditingController originController = TextEditingController();
  TextEditingController useController = TextEditingController();
  TextEditingController howToUseController = TextEditingController();

  Rxn<File> imageFile = Rxn(null);
  RxList<Category> chooseCategories = RxList<Category>();
  RxList<String> productUses = RxList<String>();
  RxList<String> howToUseList = RxList<String>();
  RxString title = RxString('');
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  final productManageController = Get.find<ProductManageController>();

  @override
  void onInit() {
    if (product == null) {
      title.value = 'Thêm sản phẩm mới';
    } else {
      title.value = 'Chỉnh sửa sản phẩm';
      _fillProductData();
    }
    super.onInit();
  }

  void _fillProductData() {
    nameController.text = product!.name;
    priceController.text = AppUtils.formatPrice(product!.cost);
    descController.text = product!.description;
    chooseCategories.addAll(product!.categories);
    FirebaseService.fetchProductDetailInfoById(product!.idProduct, (detail) {
      if (detail.introduce != null) {
        introController.text = detail.introduce!;
      }
      originController.text = detail.origin;
      productUses.value = detail.uses;
      howToUseList.value = detail.howToUse;
    }, (error) {
      log('Error: $error');
      EasyLoading.showError('Đã có lỗi xảy ra');
    });
  }

  void chooseImage() {
    ImagePicker picker = ImagePicker();
    picker.pickImage(source: ImageSource.gallery).then((data) {
      if (data == null) {
      } else {
        imageFile.value = File(data.path);
      }
    });
  }

  void onConfirmAddProduct() {
    if (product == null) {
      if (globalKey.currentState!.validate()) {
        if (imageFile.value == null) {
          EasyLoading.showError('Ảnh sản phẩm là bắt buộc');
        } else if (productUses.isEmpty) {
          EasyLoading.showError('Công dụng sản phẩm là bắt buộc');
        } else if (howToUseList.isEmpty) {
          EasyLoading.showError('Chưa có hướng dẫn sử dụng sản phẩm');
        } else {
          EasyLoading.show(status: 'Đang upload hình ảnh');
          FirebaseService.fetchBrandInfo((branInfo) {
            String idProduct = const Uuid().v4();
            double price = double.tryParse(priceController.text) ?? 0;
            FirebaseService.uploadImageProduct(idProduct, imageFile.value!,
                (image) {
              EasyLoading.dismiss();
              Product product = Product(
                  idProduct,
                  nameController.text,
                  image,
                  descController.text,
                  price,
                  null,
                  branInfo,
                  chooseCategories,
                  null);
              FirebaseService.writeProductToDb(product);
              ProductDetail productDetail = ProductDetail(
                  idProduct,
                  nameController.text,
                  image,
                  descController.text,
                  price,
                  null,
                  introController.text,
                  null,
                  productUses,
                  howToUseList,
                  originController.text,
                  null,
                  branInfo,
                  chooseCategories,
                  null);
              FirebaseService.writeDetailProductToDb(productDetail);
              productManageController.productList.add(product);
              EasyLoading.showSuccess('Đăng sản phẩm thành công');
            }, (error) {
              log('Error: $error');
              EasyLoading.showError('Đã có lỗi xảy ra');
            });
          });
        }
      }
    }
  }
}
