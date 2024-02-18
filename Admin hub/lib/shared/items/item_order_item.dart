import 'dart:developer';

import 'package:beauty_hub_admin/models/order_item.dart';
import 'package:beauty_hub_admin/models/product.dart';
import 'package:beauty_hub_admin/shared/services/firebase_service.dart';
import 'package:beauty_hub_admin/shared/utils/app_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ItemOrderItem extends StatefulWidget {
  final OrderItem item;

  const ItemOrderItem({
    super.key,
    required this.item,
  });

  @override
  State<ItemOrderItem> createState() => _ItemOrderItemState();
}

class _ItemOrderItemState extends State<ItemOrderItem> {
  Product? product;

  @override
  void initState() {
    getProductInfo(widget.item.productId);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ItemOrderItem oldWidget) {
    if (oldWidget.item == widget.item) {
      return;
    } else {
      getProductInfo(widget.item.productId);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return product == null
        ? const SizedBox()
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              CachedNetworkImage(
                imageUrl: product!.image,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      )),
                ),
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      product!.name,
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Giá sản phẩm: ${AppUtils.formatPrice(product!.getPrice())}',
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'x${widget.item.quantity.toString()}',
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          );
  }

  void getProductInfo(String id) {
    FirebaseService.fetchProductInfoById(id, (productInfo) {
      setState(() {
        product = productInfo;
      });
    }, (e) => log("Error: $e"));
  }
}
