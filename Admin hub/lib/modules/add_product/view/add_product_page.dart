import 'dart:developer';

import 'package:beauty_hub_admin/modules/add_product/controller/add_product_controller.dart';
import 'package:beauty_hub_admin/modules/add_product/view/product_category_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddProductPage extends GetView<AddProductController> {
  const AddProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          centerTitle: true,
          title: Obx(
            () => Text(
              controller.title.value,
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          )),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Form(
          key: controller.globalKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              RichText(
                  text: const TextSpan(
                      text: 'Tên sản phẩm ',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                    TextSpan(
                        text: '*',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ))
                  ])),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: controller.nameController,
                validator: (input) => input == null || input.isEmpty
                    ? 'Trường dữ liệu này là bắt buộc'
                    : null,
                decoration: const InputDecoration(
                  hintText: 'Nhập tên sản phẩm',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                ),
              ),
              const SizedBox(height: 12.0),
              RichText(
                  text: const TextSpan(
                      text: 'Giá sản phẩm ',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                    TextSpan(
                        text: '*',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ))
                  ])),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: controller.priceController,
                keyboardType: TextInputType.number,
                validator: (input) => input == null || input.isEmpty
                    ? 'Trường dữ liệu này là bắt buộc'
                    : null,
                decoration: const InputDecoration(
                  hintText: 'Nhập giá sản phẩm',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                ),
              ),
              const SizedBox(height: 12.0),
              RichText(
                  text: const TextSpan(
                      text: 'Ảnh sản phẩm ',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                    TextSpan(
                        text: '*',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ))
                  ])),
              const SizedBox(height: 8.0),
              Obx(() => controller.imageFile.value == null
                  ? Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.grey.shade200,
                      ),
                      child: IconButton(
                          onPressed: () {
                            controller.chooseImage();
                          },
                          icon: const Icon(
                            Icons.add,
                            color: Colors.black,
                          )))
                  : Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.grey.shade200,
                        image: DecorationImage(
                          image: FileImage(controller.imageFile.value!),
                          fit: BoxFit.cover,
                        ),
                      ))),
              const SizedBox(height: 12.0),
              const Text(
                'Giới thiệu về sản phẩm',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: controller.introController,
                maxLines: 10,
                decoration: const InputDecoration(
                  hintText: 'Nhập giới thiệu sản phẩm',
                  helperMaxLines: 5,
                  helperText:
                      'Hãy viết giới thiệu về sản phẩm một cách hấp dẫn nhất, ngắn ngọn, dễ hiểu. Đó sẽ một cách thu hút người dùng hiệu quả và giúp bạn gia tăng doanh số bán hàng.',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 8.0,
                  ),
                ),
              ),
              const SizedBox(height: 12.0),
              RichText(
                  text: const TextSpan(
                      text: 'Mô tả ',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                    TextSpan(
                        text: '*',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ))
                  ])),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: controller.descController,
                maxLines: 5,
                validator: (input) => input == null || input.isEmpty
                    ? 'Trường dữ liệu này là bắt buộc'
                    : null,
                decoration: const InputDecoration(
                  hintText: 'Nhập mô tả về sản phẩm',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 8.0,
                  ),
                ),
              ),
              const SizedBox(height: 12.0),
              ProductCategoryList(
                  productCategories: controller.chooseCategories,
                  onChoose: (item) {
                    controller.chooseCategories.add(item);
                    log('Category list: ${controller.chooseCategories.length}');
                  }),
              const SizedBox(height: 12.0),
              RichText(
                  text: const TextSpan(
                      text: 'Xuất sứ của sản phẩm ',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                    TextSpan(
                        text: '*',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ))
                  ])),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: controller.originController,
                validator: (input) => input == null || input.isEmpty
                    ? 'Trường dữ liệu này là bắt buộc'
                    : null,
                decoration: const InputDecoration(
                  hintText: 'Nhập xuất sứ',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 8.0,
                  ),
                ),
              ),
              const SizedBox(height: 12.0),
              RichText(
                  text: const TextSpan(
                      text: 'Công dụng của sản phẩm ',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                    TextSpan(
                        text: '*',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ))
                  ])),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: controller.useController,
                onFieldSubmitted: (value) {
                  if (value.isNotEmpty) {
                    controller.productUses.add(value);
                  }
                },
                validator: (input) => input == null || input.isEmpty
                    ? 'Trường dữ liệu này là bắt buộc'
                    : null,
                decoration: const InputDecoration(
                  hintText: 'Nhập công dụng',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 8.0,
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              Obx(() => controller.productUses.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.productUses.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => ListTile(
                            leading: Text(
                              (index + 1).toString(),
                              style: const TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            title: Text(
                              controller.productUses[index],
                              style: const TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ))
                  : const SizedBox()),
              const SizedBox(height: 12.0),
              RichText(
                  text: const TextSpan(
                      text: 'Cách sử dụng của sản phẩm ',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                    TextSpan(
                        text: '*',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ))
                  ])),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: controller.howToUseController,
                onFieldSubmitted: (value) {
                  if (value.isNotEmpty) {
                    controller.howToUseList.add(value);
                  }
                },
                validator: (input) => input == null || input.isEmpty
                    ? 'Trường dữ liệu này là bắt buộc'
                    : null,
                decoration: const InputDecoration(
                  hintText: 'Nhập cách sử dụng',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 8.0,
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              Obx(() => controller.howToUseList.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.howToUseList.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => ListTile(
                            leading: Text(
                              (index + 1).toString(),
                              style: const TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            title: Text(
                              controller.howToUseList[index],
                              style: const TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ))
                  : const SizedBox()),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
      persistentFooterButtons: [
        MaterialButton(
          onPressed: () {
            controller.onConfirmAddProduct();
          },
          color: Colors.green,
          minWidth: Get.width,
          height: 48.0,
          child: const Text(
            'Xác nhận',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}
