import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gameaway/services/db.dart';
import 'package:gameaway/services/order.dart';

import 'history_card.dart';
import 'loading.dart';

class BuyHistory extends StatelessWidget {
  const BuyHistory({Key? key, required this.uid}) : super(key: key);

  final String uid;

  Future<List<Order>> getOrders() async {
    List<Order> orders = <Order>[];
    var buyerRef = DBService.userCollection.doc(uid);
    var o = await DBService.ordersCollection
        .where("buyer", isEqualTo: buyerRef)
        .get();
    for (var element in o.docs) {
      DocumentReference currentProduct = element.get("product");
      String currentProductName = (await currentProduct.get()).get("name");
      num currentProductPrice = (await currentProduct.get()).get("price");
      String currentProductPicture =
          (await currentProduct.get()).get("picture");
      String currentPid = currentProduct.id;
      orders.add(Order(
          oid: element.id,
          reviewed: element.get("reviewed"),
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
            return const Center(child: Text("No purchase has been made"));
          }
          return ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: orders.length,
            itemBuilder: (context, index) {
              return HistoryCard(order: orders[index]);
            },
          );
        });
  }
}
