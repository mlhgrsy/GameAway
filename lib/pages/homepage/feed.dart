import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gameaway/pages/seller_page.dart';
import 'package:gameaway/services/db.dart';
import 'package:gameaway/services/util.dart';
import 'package:gameaway/utils/dimensions.dart';
import 'package:gameaway/utils/styles.dart';
import 'package:gameaway/views/action_bar.dart';
import 'package:gameaway/views/category_tag_selection.dart';
import 'package:gameaway/views/loading_indicator.dart';
import 'package:gameaway/views/product_preview.dart';
import 'package:provider/provider.dart';

class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  DBService db = DBService();
  List<Product>? _products;
  List<Product>? _promotions;
  List<Product>? _recommendations;

  Future<void> getProducts() async {
    // Products
    var r = await DBService.productCollection.get();
    var _productsTemp = r.docs
        .map<Product>((doc) => Product(
            oldPrice: doc['oldPrice'],
            pid: doc.id,
            price: doc['price'],
            stocks: doc['stocks'],
            productName: doc['name'],
            category: doc['category'],
            tag: doc['tag'],
            seller: "Anonymous Seller",
            url: doc['picture'],
            rating: Util.avg(doc['rating'])))
        .toList();

    for (var i = 0; i < r.docs.length; i++) {
      var r2 = await r.docs[i]["seller"].get();
      if (r2.data() != null) _productsTemp[i].seller = r2.data()["name"];
    }

    List<Product> _recommendationsTemp = [];
    var currentUser = Provider.of<User?>(context, listen: false);
    if (currentUser == null) {
      _recommendationsTemp =
          _productsTemp.where((p) => (p.rating >= 4.5)).toList();
    } else {
      var userRef = DBService.userCollection.doc(currentUser.uid);
      var now = DateTime.now();
      var monthAgo = DateTime(now.year, now.month - 1, now.day);
      print(monthAgo);
      var lastOrders = (await DBService.ordersCollection
              .where("buyer", isEqualTo: userRef)
              .where("purchaseDate",
                  isGreaterThan: Timestamp.fromDate(monthAgo))
              .get())
          .docs;
      print(lastOrders);
      if (lastOrders.isEmpty) {
        _recommendationsTemp =
            _productsTemp.where((p) => (p.rating >= 4)).toList();
      } else {
        var tagsList = <String>[];
        for (var element in lastOrders) {
          DocumentReference productRef = element.get("product");
          tagsList.add((await productRef.get()).get("tag"));
        }
        _recommendationsTemp = _productsTemp
            .where((element) => tagsList.contains(element.tag))
            .toList();
      }
    }

    setState(() {
      _products = _productsTemp;
      _promotions = _products?.where((p) => (p.oldPrice > p.price)).toList();
      _recommendations = _recommendationsTemp;
    });
  }

  @override
  void initState() {
    super.initState();
    getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ActionBar(),
      body: _products == null
          ? const LoadingIndicator()
          : SingleChildScrollView(
              child: Column(
                children: [
                  OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, "homepage/explore")
                            .then((value) {
                          setState(() {});
                        });
                        // Navigator.of(context).push(MaterialPageRoute(
                        //     builder: (context) => const SellerPage(
                        //         sellerID: "ZDgxpoysU8aFPC3y5doCdFXLBwS2")));
                      },
                      icon: const Icon(Icons.search),
                      label: const Text("Explore Products")),
                  Text(
                    "Promotions",
                    style: kHeadingTextStyle,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: Dimen.regularPadding,
                      child: Row(
                        children: List.generate(
                            _promotions!.length,
                            (index) => Row(children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: ProductPreview(
                                        editable: false,
                                        refreshFunc: () {
                                          setState(() {});
                                        },
                                        product: _promotions![index]),
                                  ),
                                ])),
                      ),
                    ),
                  ),
                  Text(
                    "Recommendations",
                    style: kHeadingTextStyle,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: Dimen.regularPadding,
                      child: Row(
                        children: List.generate(
                            _recommendations!.length,
                            (index) => Row(children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: ProductPreview(
                                        refreshFunc: () {
                                          setState(() {});
                                        },
                                        product: _recommendations![index]),
                                  ),
                                ])),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
