import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gameaway/services/basket.dart';
import 'package:gameaway/services/db.dart';
import 'package:gameaway/services/util.dart';
import 'package:gameaway/utils/colors.dart';
import 'package:gameaway/utils/dimensions.dart';
import 'package:gameaway/views/action_bar.dart';
import 'package:gameaway/views/product_preview.dart';

import 'mock_payment.dart';

class BasketPage extends StatefulWidget {
  const BasketPage({Key? key}) : super(key: key);

  @override
  _BasketPageState createState() => _BasketPageState();
}

class _BasketPageState extends State<BasketPage> {
  num sum = 0;
  List<Map<String, String>> orderInfo = <Map<String, String>>[];

  Future<List<Product>> getProducts() async {
    orderInfo = <Map<String, String>>[];
    DBService db = DBService();
    var pids = await Basket.getItems();
    if (pids!.isEmpty) {
      return <Product>[];
    } else {
      List<Product> productsInBasket = <Product>[];
      for (var i = 0; i < pids.length; i++) {
        DocumentReference productReference = db.productCollection.doc(pids[i]);
        var currentSnapshot = await productReference.get();
        DocumentReference sellerRef = currentSnapshot.get("seller");
        String sellerName = (await sellerRef.get()).get("name");
        var currentProduct = Product(
            pid: pids[i],
            stocks: currentSnapshot.get("stocks"),
            url: currentSnapshot.get("picture"),
            productName: currentSnapshot.get("name"),
            rating: Util.avg(currentSnapshot.get("rating")),
            price: currentSnapshot.get("price"),
            seller: sellerName);
        productsInBasket.add(currentProduct);
        orderInfo.add({"seller": sellerRef.id, "product": pids[i]});
      }
      num sum_price = 0;
      int i = 0;
      while (i < productsInBasket.length) {
        sum_price = sum_price + productsInBasket[i].price;
        i = i + 1;
      }
      sum = sum_price;
      return productsInBasket;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ActionBar(title: "Basket"),
      body: FutureBuilder(
          future: getProducts(),
          builder: (context, AsyncSnapshot asyncSnapshot) {
            if (!asyncSnapshot.hasData) return const Text("Loading...");
            List<Product> products = asyncSnapshot.data;
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  fit: FlexFit.loose,
                  child: Container(
                    height: 475,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        if (products != null) {
                          return Padding(
                            padding: Dimen.listPadding,
                            child: Card(
                              child: ListTile(
                                  onTap: () {},
                                  title: Column(
                                    children: [
                                      Text(
                                        products[index].productName,
                                        style: const TextStyle(
                                            color: AppColors.secondary,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  leading: Image.network(products[index].url),
                                  subtitle: Text(
                                    '\$ ${products[index].price}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  trailing: TextButton(
                                    onPressed: () async {
                                      await Basket.removeItem(
                                          products[index].pid);
                                      int i = 0;
                                      num sumPrice = 0;
                                      while (i < products.length) {
                                        sumPrice =
                                            sumPrice + products[index].price;
                                        i = i + 1;
                                      }
                                      setState(() {
                                        sum = sumPrice;
                                      });
                                    },
                                    child: Text(
                                      "X",
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 30),
                                    ),
                                  )
                                  //Icon(Icons.delete,color: Colors.red,) ,
                                  ),
                            ),
                          );
                        } else {
                          return Center(
                              child: Text("no purchase has been made"));
                        }
                      },
                    ),
                  ),
                ),
                Column(children: [
                  SizedBox(
                    height: 40,
                  ),
                  Divider(
                    height: 2,
                  ),
                  Text("The sum is \$ $sum")
                ]),
                Divider(
                  height: 2,
                  thickness: 3,
                ),
                SizedBox(
                  height: 15,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PaymentScreen(
                                    sum: sum,
                                    orderInfo: orderInfo,
                                  )));
                    },
                    child: Text("purchase"))
              ],
            );
          }),
    );
  }
}
