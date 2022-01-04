import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gameaway/pages/seller_page.dart';
import 'package:gameaway/services/basket.dart';
import 'package:gameaway/services/db.dart';
import 'package:gameaway/services/util.dart';
import 'package:gameaway/utils/colors.dart';
import 'package:gameaway/utils/dimensions.dart';
import 'package:gameaway/utils/styles.dart';
import 'package:gameaway/views/action_bar.dart';
import 'package:gameaway/views/product_preview.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key, required this.productID}) : super(key: key);
  final String productID;

  @override
  State<ProductPage> createState() => _ProductPage();
}

class _ProductPage extends State<ProductPage> {
  DBService db = DBService();
  String? _sellerID;
  String productName = "";

  Future<Product> getProduct() async {
    var docSnap = await db.productCollection.doc(widget.productID).get();
    var product = Product(
        pid: widget.productID,
        productName: docSnap.get("name"),
        rating: Util.avg(docSnap.get("rating")),
        price: docSnap.get("price"),
        seller: "Anonymous Seller",
        url: docSnap.get("picture"),
        category: docSnap.get("category"),
        stocks: docSnap.get("stocks"),
        tag: docSnap.get("tag"),
        desc: docSnap.get("desc"));

    DocumentReference sellerRef = await docSnap.get("seller");
    String sellerName = (await sellerRef.get()).get("name");
    product.seller = sellerName;
    _sellerID = (await sellerRef.get()).id;
    setState(() {
      productName = product.productName;
    });
    return product;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(productName),
      ),
      body: FutureBuilder(
          future: getProduct(),
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) return const Text("Loading...");
            Product _product = snapshot.data;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: Dimen.regularPadding,
                        child: CircleAvatar(
                          radius: 35,
                          backgroundImage: NetworkImage(
                              _product.url), //burası pp widget fnc yazılacak
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      SizedBox(
                        width: 200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Price: ${_product.price}\$",
                              style: kButtonLightTextStyle,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RatingBarIndicator(
                                  rating: _product.rating as double,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  itemCount: 5,
                                  itemSize: 25.0,
                                  unratedColor: Colors.amber.withAlpha(50),
                                  direction: Axis.horizontal,
                                ),
                                Text(
                                  "${_product.rating}",
                                  style: const TextStyle(color: Colors.amber),
                                ),
                              ],
                            ),
                            Visibility(
                              visible: _product.stocks <= 0,
                              child: const Text(
                                "Out of stock",
                                style: TextStyle(color: AppColors.notification),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: Dimen.regularPadding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        SellerPage(sellerID: _sellerID!)));
                              },
                              child: Text(
                                "Seller: ${_product.seller}",
                                style: kButtonLightTextStyle,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              "Category: ${_product.category}",
                              style: kButtonLightTextStyle,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              "Tag: ${_product.tag}",
                              style: kButtonLightTextStyle,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              "Stock: ${_product.stocks}",
                              style: kButtonLightTextStyle,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              "Description:",
                              style: kButtonLightTextStyle,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Visibility(
                            visible: _product.stocks > 0,
                            child: OutlinedButton.icon(
                                onPressed: () async {
                                  if (await Basket.isInBasket(
                                      widget.productID)) {
                                    showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                              title:
                                                  const Text("Already Added"),
                                              content: const Text(
                                                  "This product is already in your basket"),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(_);
                                                    },
                                                    child: const Text("Ok"))
                                              ],
                                            ));
                                  } else {
                                    Basket.addItem(widget.productID);
                                    showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                              title: const Text("Success"),
                                              content: const Text(
                                                  "The product has been added to your basket!"),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(_);
                                                    },
                                                    child: const Text("Ok"))
                                              ],
                                            ));
                                  }
                                },
                                icon: const Icon(Icons.shopping_cart),
                                label: const Text("Add to Basket")),
                          ),
                          OutlinedButton.icon(
                              onPressed: () {
                                Navigator.pushNamed(context, "homepage/explore")
                                    .then((value) {
                                  setState(() {});
                                });
                              },
                              icon: const Icon(Icons.favorite),
                              label: const Text("Add to Favorites"))
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: Dimen.regularPadding,
                    child: Text(
                      _product.desc,
                      style: const TextStyle(color: Colors.black),
                      textAlign: TextAlign.left,
                      //details
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(context, "homepage/explore")
                                .then((value) {
                              setState(() {});
                            });
                          },
                          icon: const Icon(Icons.comment),
                          label: const Text("See Reviews")),
                    ],
                  )
                ],
              ),
            );
          }),
      backgroundColor: const Color.fromRGBO(200, 200, 200, 1.0),
    );
  }
}
