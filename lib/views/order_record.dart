import 'package:flutter/material.dart';
import 'package:gameaway/services/order.dart';
import 'package:gameaway/utils/colors.dart';
import 'package:gameaway/utils/dimensions.dart';

class OrderRecord extends StatelessWidget {
  const OrderRecord({Key? key, required this.order}) : super(key: key);
  final Order order;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Dimen.listPadding,
      child: Card(
        color: AppColors.captionColor,
        child: ListTile(
          onTap: () {},
          title: Column(
            children: [
              Text(
                order.productName,
                style: const TextStyle(
                    color: AppColors.notification, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          leading: Image.network(order.url),
          trailing: Text('\$ ${order.price}'),
        ),
      ),
    );
  }
}
