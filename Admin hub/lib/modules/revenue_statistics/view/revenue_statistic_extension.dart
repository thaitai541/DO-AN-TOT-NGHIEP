part of 'revenue_statistics_page.dart';

extension RevenueStatisticsExtension on RevenueStatisticsPage {
  Widget _buildRevenue() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        ListTile(
          title: const Text(
            'Tổng doanh thu',
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.black,
            ),
          ),
          subtitle: Text(
            '${AppUtils.formatPrice(controller.revenueStore.value)}đ',
            style: const TextStyle(
              fontSize: 18.0,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.event,
              color: Colors.grey,
            ),
          ),
        ),
        const SizedBox(height: 8.0),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        border:
                            Border.all(width: 0.5, color: Colors.deepOrange)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Đang chờ xác nhận',
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.orange,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4.0),
                        RichText(
                            text: TextSpan(
                                text: '${controller.awaitingOrderList.length} ',
                                style: const TextStyle(
                                    fontSize: 24.0,
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold),
                                children: const [
                              TextSpan(
                                text: 'đơn hàng',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.orangeAccent,
                                ),
                              )
                            ])),
                        const SizedBox(height: 4.0),
                        Text(
                          'Doanh thu: ${AppUtils.formatPrice(controller.awaitingRevenueStore.value)} đồng',
                          maxLines: 1,
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: Colors.orangeAccent,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Container(
                    width: Get.width * 0.5,
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        border: Border.all(width: 0.5, color: Colors.green)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Đã quyết toán',
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.green,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4.0),
                        RichText(
                            text: TextSpan(
                                text: '${controller.confirmOrderList.length} ',
                                style: const TextStyle(
                                    fontSize: 24.0,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold),
                                children: const [
                              TextSpan(
                                text: 'đơn hàng',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.green,
                                ),
                              )
                            ])),
                        const SizedBox(height: 4.0),
                        Text(
                          'Doanh thu: ${AppUtils.formatPrice(controller.confirmRevenueStore.value)} đồng',
                          maxLines: 1,
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: Colors.green,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Container(
                width: Get.width * 0.5,
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    border: Border.all(width: 0.5, color: Colors.red)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Đã hủy',
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.red,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4.0),
                    RichText(
                        text: TextSpan(
                            text: '${controller.cancelOrderList.length} ',
                            style: const TextStyle(
                                fontSize: 24.0,
                                color: Colors.red,
                                fontWeight: FontWeight.bold),
                            children: const [
                          TextSpan(
                            text: 'đơn hàng',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.red,
                            ),
                          )
                        ]))
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
