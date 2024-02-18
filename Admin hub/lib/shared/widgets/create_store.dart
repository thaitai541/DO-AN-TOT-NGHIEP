import 'dart:developer';
import 'dart:io';

import 'package:beauty_hub_admin/models/brand.dart';
import 'package:beauty_hub_admin/shared/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';

class CreateStore extends StatefulWidget {
  const CreateStore({super.key});

  @override
  State<CreateStore> createState() => _CreateStoreState();
}

class _CreateStoreState extends State<CreateStore> {
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController descController = TextEditingController();

  File? imageFile;
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height,
      margin: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Form(
        key: globalKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 56.0),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: 48.0,
                  height: 48.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade200,
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
              ),
              title: const Text(
                'Tạo cửa hàng',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: const Text(
                'Hãy bắt đầu kinh doanh mỹ phẩm trên nền tảng ứng dụng của chúng tôi',
                style: TextStyle(fontSize: 14.0, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 12.0),
            RichText(
                text: const TextSpan(
                    text: 'Logo cửa hàng ',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                  TextSpan(
                      text: '*',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.red,
                      ))
                ])),
            const SizedBox(height: 8.0),
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              onTap: () {
                chooseImage();
              },
              child: Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: 1, color: Colors.grey),
                  image: imageFile != null
                      ? DecorationImage(
                          image: FileImage(imageFile!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: const Icon(
                  Icons.add_a_photo_outlined,
                  color: Colors.green,
                ),
              ),
            ),
            const SizedBox(height: 12.0),
            RichText(
                text: const TextSpan(
                    text: 'Tên cửa hàng ',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                  TextSpan(
                      text: '*',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.red,
                      ))
                ])),
            const SizedBox(height: 8.0),
            TextFormField(
              controller: nameController,
              validator: (input) =>
                  input == null ? 'Tên cửa hàng là bắt buộc' : null,
              decoration: const InputDecoration(
                hintText: 'Nhập tên cửa hàng',
                contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12.0),
            RichText(
                text: const TextSpan(
                    text: 'Địa chỉ ',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                  TextSpan(
                      text: '*',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.red,
                      ))
                ])),
            const SizedBox(height: 8.0),
            TextFormField(
              controller: addressController,
              validator: (input) =>
                  input == null ? 'Địa chỉ cửa hàng là bắt buộc' : null,
              decoration: const InputDecoration(
                hintText: 'Nhập địa chỉ',
                contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12.0),
            RichText(
                text: const TextSpan(
              text: 'Mô tả về cửa hàng',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            )),
            const SizedBox(height: 8.0),
            TextFormField(
              controller: descController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Nhập mô tả',
                contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                border: OutlineInputBorder(),
              ),
            ),
            const Spacer(),
            ButtonTheme(
              height: 48.0,
              minWidth: Get.width,
              child: MaterialButton(
                onPressed: () {
                  onCreateStore();
                },
                color: Colors.green,
                elevation: 0.0,
                disabledElevation: 0.0,
                child: const Text(
                  'Tạo cửa hàng',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void chooseImage() {
    ImagePicker picker = ImagePicker();
    picker.pickImage(source: ImageSource.gallery).then((data) {
      if (data != null) {
        setState(() {
          imageFile = File(data.path);
        });
      }
    });
  }

  void onCreateStore() {
    if (globalKey.currentState!.validate()) {
      if (imageFile == null) {
        EasyLoading.showToast('Logo cửa hàng chưa được đặt');
      } else {
        FirebaseService.uploadLogoBrand(imageFile!, (imageUrl) {
          final prefs = Get.find<SharedPreferences>();
          final idBrand = prefs.getString(AppConstants.idUser);
          if (idBrand != null) {
            Brand brand = Brand(idBrand, nameController.text, imageUrl);
            FirebaseService.createStore(brand, () {
              Navigator.pop(context);
            }, (error) => log('Error: $error'));
          }
        }, (error) {
          log('Error: $error');
          EasyLoading.showError('Đã có lỗi xảy ra');
        });
      }
    }
  }
}
