import 'dart:developer';

import 'package:beauty_hub_admin/modules/add_product/controller/add_product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/category.dart';
import '../../../shared/services/firebase_service.dart';

class ProductCategoryList extends StatefulWidget {
  final List<Category> productCategories;
  final Function(Category) onChoose;

  const ProductCategoryList({
    super.key,
    required this.onChoose,
    required this.productCategories,
  });

  @override
  State<ProductCategoryList> createState() => _ProductCategoryListState();
}

class _ProductCategoryListState extends State<ProductCategoryList> {
  List<Category> chooseCategoryList = [];
  List<Category> categoryList = [];

  final controller = Get.find<AddProductController>();

  @override
  void initState() {
    getCategoryList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        RichText(
            text: const TextSpan(
                text: 'Sản phẩm của bạn thuộc nhóm nào ? ',
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
        categoryList.isNotEmpty
            ? Wrap(
                spacing: 4.0,
                children: categoryList
                    .map((e) => InkWell(
                          onTap: () {
                            log('Choose item');
                            setState(() {
                            //  chooseCategoryList.add(e);
                              controller.chooseCategories.add(e);
                            });
                          },
                          child: Chip(
                            backgroundColor: chooseCategoryList
                                    .where((item) => item.id == e.id)
                                    .isNotEmpty
                                ? Colors.green
                                : Colors.white,
                            label: Text(
                              e.name,
                              style: TextStyle(
                                color: chooseCategoryList
                                        .where((item) => item.id == e.id)
                                        .isNotEmpty
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            onDeleted: () {
                              log('Deleted item');
                              setState(() {
                                //chooseCategoryList.remove(e);
                                controller.chooseCategories.remove(e);
                              });
                            },
                            deleteIconColor: Colors.white,
                          ),
                        ))
                    .toList(),
              )
            : const Center(child: CircularProgressIndicator()),
      ],
    );
  }

  void getCategoryList() {
    chooseCategoryList = widget.productCategories;
    FirebaseService.fetchCategories((dataList) {
      setState(() {
        categoryList = dataList;
      });
    });
  }
}
