import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gameaway/pages/sold_products.dart';
import 'package:gameaway/services/db.dart';
import 'package:gameaway/services/order.dart';
import 'package:gameaway/views/sell_history_card.dart';

import 'loading.dart';

class SellHistory extends StatefulWidget {
  const SellHistory({Key? key, required this.uid}) : super(key: key);
  final String uid;

  @override
  State<SellHistory> createState() => _SellHistoryState();
}

class _SellHistoryState extends State<SellHistory> {
  Future<List<Order>> getOrders() async {
    List<Order> orders = <Order>[];
    var sellerRef = DBService.userCollection.doc(widget.uid);
    var o = await DBService.ordersCollection
        .where("seller", isEqualTo: sellerRef)
        .get();
    for (var element in o.docs) {
      DocumentReference currentProduct = element.get("product");
      DocumentReference currentBuyer = element.get("buyer");
      String currentProductName = (await currentProduct.get()).get("name");
      num currentProductPrice = (await currentProduct.get()).get("price");
      String currentBuyerName = (await currentBuyer.get()).get("name");
      String currentProductPicture =
          (await currentProduct.get()).get("picture");
      String currentPid = currentProduct.id;
      orders.add(Order(
          buyer: currentBuyerName,
          oid: element.id,
          url: currentProductPicture,
          productName: currentProductName,
          pid: currentPid,
          price: currentProductPrice,
          purchaseDate: element.get("purchaseDate")));
    }
    return orders;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getOrders(),
        builder: (context, AsyncSnapshot asyncSnapshot) {
          if (!asyncSnapshot.hasData) return const Loading();
          List<Order> orders = asyncSnapshot.data;
          if (orders.isEmpty) {
            return const Center(child: Text("No products have been sold"));
          }
          return ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: orders.length,
            itemBuilder: (context, index) {
              return SellHistoryCard(order: orders[index]);
            },
          );
        });
  }
}
