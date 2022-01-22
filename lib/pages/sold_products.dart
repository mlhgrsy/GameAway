import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gameaway/services/db.dart';
import 'package:gameaway/services/order.dart';
import 'package:gameaway/views/action_bar.dart';
import 'package:gameaway/views/loading_indicator.dart';
import 'package:gameaway/views/order_record.dart';

class SoldProducts extends StatefulWidget {
  const SoldProducts({Key? key, required this.sellerID}) : super(key: key);
  final String sellerID;

  @override
  _SoldProductsState createState() => _SoldProductsState();
}

class _SoldProductsState extends State<SoldProducts> {
  Future<List<Order>> getOrders() async {
    List<Order> orders = <Order>[];
    var sellerRef = DBService.userCollection.doc(widget.sellerID);
    var o = await DBService.ordersCollection
        .where("seller", isEqualTo: sellerRef)
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
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      FutureBuilder(
          future: getOrders(),
          builder: (context, AsyncSnapshot asyncSnapshot) {
            if (!asyncSnapshot.hasData) return const LoadingIndicator();
            List<Order> orders = asyncSnapshot.data;
            return Flexible(
              fit: FlexFit.loose,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  if (orders.isNotEmpty) {
                    return OrderRecord(order: orders[index]);
                  } else {
                    return const Center(
                        child: Text("This user have not sold anything yet!"));
                  }
                },
              ),
            );
          }),
    ]);
  }
}
