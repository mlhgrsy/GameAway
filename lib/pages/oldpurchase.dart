import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gameaway/utils/colors.dart';
import 'package:gameaway/utils/dimensions.dart';
import 'package:gameaway/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:gameaway/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gameaway/services/db.dart';
import 'package:gameaway/views/action_bar.dart';
import 'package:gameaway/views/action_bar.dart';
import 'package:gameaway/views/product_preview.dart';

final _productPreviewList = <Product>[
  Product(
      stocks: 10,
      pid: "1",
      url:
          "https://icons.iconarchive.com/icons/femfoyou/angry-birds/256/angry-bird-icon.png",
      productName: "AngryBirds",
      rating: 3.8,
      price: 25.99,
      seller: "Seller1"),
  Product(
      stocks: 10,
      pid: "1",
      url:
          "https://icons.iconarchive.com/icons/3xhumed/mega-games-pack-40/128/Mafia-2-3-icon.png",
      productName: "Mafia2",
      rating: 3.9,
      price: 119.99,
      seller: "Seller2"),
  Product(
      stocks: 10,
      pid: "1",
      url:
          "https://icons.iconarchive.com/icons/3xhumed/mega-games-pack-34/128/Max-Payne-3-2-icon.png",
      productName: "Max Payne 3",
      rating: 4.4,
      price: 124.99,
      seller: "Seller1")
];

class oldpurchase extends StatefulWidget {
  const oldpurchase({Key? key}) : super(key: key);

  @override
  _oldpurchaseState createState() => _oldpurchaseState();
}

class _oldpurchaseState extends State<oldpurchase> {
  @override
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Widget build(BuildContext context) {
    CollectionReference products = _firestore.collection('product');
    DBService db = DBService();
    return Scaffold(
      appBar: ActionBar(title: "Old Purchases"),
      body: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        StreamBuilder<QuerySnapshot>(
            stream: products.snapshots(),
            builder: (context, AsyncSnapshot asyncSnapshot) {
              if (!asyncSnapshot.hasData) return const Text("Loading...");
              print(asyncSnapshot.data.docs);
              List<DocumentSnapshot> listofnotify = asyncSnapshot.data.docs;
              return Flexible(
                fit: FlexFit.loose,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: listofnotify.length,
                  itemBuilder: (context, index) {
                    if (listofnotify != null) {
                      return Padding(
                        padding: Dimen.listPadding,
                        child: Card(
                          color: AppColors.captionColor,
                          child: ListTile(
                            onTap: () {},
                            title: Column(
                              children: [
                                Text(
                                  '${listofnotify[index]["name"]}',
                                  style: TextStyle(
                                      color: AppColors.notification,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            leading:
                                Image.network(listofnotify[index]["picture"]),
                            trailing:
                                Text('\$ ${listofnotify[index]["price"]}'),
                          ),
                        ),
                      );
                    } else {
                      return Center(child: Text("no purchase has been made"));
                    }
                  },
                ),
              );
            }),
      ]),
    );
  }
}
