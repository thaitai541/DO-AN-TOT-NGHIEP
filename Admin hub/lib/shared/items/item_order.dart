import 'dart:developer';

import 'package:beauty_hub_admin/models/order.dart';
import 'package:beauty_hub_admin/models/user_info.dart';
import 'package:beauty_hub_admin/shared/items/item_order_item.dart';
import 'package:beauty_hub_admin/shared/services/firebase_service.dart';
import 'package:beauty_hub_admin/shared/utils/app_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../models/order_item.dart';

class ItemOrder extends StatefulWidget {
  final Order order;
  final Function(String) onConfirm;
  final Function(String) onCancel;

  const ItemOrder({
    super.key,
    required this.order,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  State<ItemOrder> createState() => _ItemOrderState();
}

class _ItemOrderState extends State<ItemOrder> {
  List<OrderItem> orderItems = [];
  UserInfo? userInfo;
  String statusOrder = '';

  @override
  void initState() {
    orderItems = widget.order.orderItems;
    statusOrder = widget.order.status;
    getUserInfo();
    super.initState();
  }

  void getUserInfo() {
    FirebaseService.fetchUserInfo(widget.order.userID, (info) {
      setState(() {
        userInfo = info;
      });
    }, (error) => log('Error: $error'));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'ID: ${widget.order.idOrder}',
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 8.0),
          userInfo == null
              ? const Center(child: CircularProgressIndicator())
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        userInfo!.avatar == null
                            ? Container(
                                width: 30.0,
                                height: 30.0,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.green,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  AppUtils.generateNameAvatar(
                                      userInfo!.fullName),
                                  style: const TextStyle(color: Colors.white),
                                ))
                            : CachedNetworkImage(
                                imageUrl: userInfo!.avatar!,
                                width: 30,
                                height: 30,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4.0),
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      )),
                                ),
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                        const SizedBox(width: 8.0),
                        Text(
                          userInfo!.fullName,
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      AppUtils.formatOrderStatus(statusOrder),
                      style: TextStyle(
                        fontSize: 14.0,
                        color: AppUtils.formatOrderStatusColor(statusOrder),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
          const SizedBox(height: 12.0),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) =>
                ItemOrderItem(item: orderItems[index]),
            itemCount: orderItems.length,
          ),
          const SizedBox(height: 8.0),
          widget.order.status == "SUCCESS"
              ? const SizedBox()
              : widget.order.status == "CANCEL"
                  ? const SizedBox()
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () {
                              setState(() {
                                statusOrder = 'CANCEL';
                                widget.onCancel(widget.order.idOrder);
                              });
                            },
                            child: Text(
                              'Hủy đơn',
                              style: TextStyle(color: Colors.grey.shade500),
                            )),
                        const SizedBox(width: 12.0),
                        MaterialButton(
                            onPressed: () {
                              setState(() {
                                statusOrder = 'SUCCESS';
                                widget.onConfirm(widget.order.idOrder);
                              });
                            },
                            color: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            elevation: 0.0,
                            disabledElevation: 0.0,
                            child: const Text(
                              'Xác nhận',
                              style: TextStyle(color: Colors.white),
                            )),
                      ],
                    )
        ],
      ),
    );
  }
}
