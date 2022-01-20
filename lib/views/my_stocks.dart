import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gameaway/services/db.dart';
import 'package:gameaway/services/util.dart';
import 'package:gameaway/utils/dimensions.dart';
import 'package:gameaway/views/product_preview.dart';
import 'package:gameaway/views/stock_editor.dart';
import 'package:provider/provider.dart';

import 'loading_indicator.dart';

class MyStocks extends StatefulWidget {
  const MyStocks({Key? key}) : super(key: key);

  @override
  _MyStocksState createState() => _MyStocksState();
}

class _MyStocksState extends State<MyStocks> {
  Future<List<Product>> getProducts() async {
    DBService db = DBService();
    var sellerRef =
        DBService.userCollection.doc(Provider.of<User?>(context)!.uid);
    var productsDocs =
        (await DBService.productCollection.where("seller", isEqualTo: sellerRef).get())
            .docs;
    List<Product> productsList = <Product>[];
    for (var i = 0; i < productsDocs.length; i++) {
      var currentProductDoc = productsDocs[i];
      DocumentReference sellerRef = currentProductDoc.get("seller");
      String sellerName = (await sellerRef.get()).get("name");
      var currentProduct = Product(
          pid: currentProductDoc.id,
          stocks: currentProductDoc.get("stocks"),
          url: currentProductDoc.get("picture"),
          productName: currentProductDoc.get("name"),
          rating: Util.avg(currentProductDoc.get("rating")),
          price: currentProductDoc.get("price"),
          oldPrice: currentProductDoc.get("oldPrice"),
          seller: sellerName,
          category: currentProductDoc.get("category"),
          tag: currentProductDoc.get("tag"));
      productsList.add(currentProduct);
    }
    return productsList;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getProducts(),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const LoadingIndicator();
          } else if (snapshot.data.isEmpty) {
            return const Center(
                child:
                    Text("You are not selling any products. Try adding some!"));
          }
          List<Product> productsList = snapshot.data;
          return SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: Dimen.regularPadding,
                child: Column(
                  children: List.generate(
                      productsList.length,
                      (index) => Padding(
                        padding:
                            const EdgeInsets.symmetric(vertical: 8.0),
                        child: StockEditor(product: productsList[index]),
                      )),
                ),
              ),
            ),
          );
        });
  }
}
