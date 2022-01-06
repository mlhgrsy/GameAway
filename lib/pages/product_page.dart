import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gameaway/pages/reviews.dart';
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
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key, required this.productID, this.refreshFunc})
      : super(key: key);
  final String productID;
  final Function? refreshFunc;

  @override
  State<ProductPage> createState() => _ProductPage();
}

class _ProductPage extends State<ProductPage> {
  DBService db = DBService();
  String? _sellerID;
  String productName = "";
  bool isSellerActive = true;

  Future<Product> getProduct() async {
    var docSnap = await DBService.productCollection.doc(widget.productID).get();
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
    isSellerActive = (await sellerRef.get()).get("active");
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
        backgroundColor: AppColors.primaryBackground,
        actions: [
          FutureBuilder(
              future: SharedPreferences.getInstance(),
              builder: (context, AsyncSnapshot<SharedPreferences> snapshot) {
                if (!snapshot.hasData) return const Icon(Icons.hourglass_full);
                var prefs = snapshot.data;
                return IconButton(
                    onPressed: () {
                      if (prefs!.getStringList("favorites") == null) {
                        setState(() {
                          prefs.setStringList("favorites", [widget.productID]);
                        });
                      } else if (prefs
                          .getStringList("favorites")!
                          .contains(widget.productID)) {
                        var temp = prefs.getStringList("favorites")!;
                        temp.remove(widget.productID);
                        setState(() {
                          prefs.setStringList("favorites", temp);
                        });
                      } else {
                        var temp = prefs.getStringList("favorites")!;
                        temp.add(widget.productID);
                        setState(() {
                          prefs.setStringList("favorites", temp);
                        });
                      }
                      if (widget.refreshFunc != null) {
                        widget.refreshFunc!();
                      }
                    },
                    icon: Icon(
                        prefs!.getStringList("favorites") == null ||
                                !prefs
                                    .getStringList("favorites")!
                                    .contains(widget.productID)
                            ? Icons.favorite_outline
                            : Icons.favorite,
                        color: AppColors.notification));
              })
        ],
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
                  Container(
                    color: AppColors.primary,
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Scaffold(
                                          appBar:
                                              ActionBar(title: "Photo View"),
                                          body: InteractiveViewer(
                                            child: Image.network(
                                              _product.url,
                                              fit: BoxFit.contain,
                                              height: double.infinity,
                                              width: double.infinity,
                                              alignment: Alignment.center,
                                            ),
                                          ),
                                        )));
                          },
                          child: Container(
                            padding: Dimen.regularPadding,
                            child: CircleAvatar(
                              //farklı bir clip
                              radius: 50,
                              backgroundImage: NetworkImage(
                                _product.url,
                              ),
                              backgroundColor: Colors.transparent,
                            ),
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
                                "Price: \$ ${_product.price}",
                                style: kButtonDarkTextStyle,
                              ),
                              const SizedBox(
                                height: 15,
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
                                    "  ${_product.rating}",
                                    style: const TextStyle(
                                        color: Colors.amber, fontSize: 16),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    color: AppColors.background,
                    child: Padding(
                      padding: Dimen.regularPadding,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                            width: 1,
                          ),
                          Column(
                            children: [
                              Text(
                                "Category:",
                                style: kButtonDarkTextStyle,
                              ),
                              Text(
                                _product.category,
                                style: kButtonLightTextStyle,
                              ),
                            ],
                          ),
                          const SizedBox(
                              height: 60,
                              child: VerticalDivider(color: Colors.white)),
                          Column(
                            children: [
                              Text(
                                "Tag:",
                                style: kButtonDarkTextStyle,
                              ),
                              Text(
                                _product.tag,
                                style: kButtonLightTextStyle,
                              ),
                            ],
                          ),
                          const SizedBox(
                              height: 60,
                              child: VerticalDivider(color: Colors.white)),
                          Column(
                            children: [
                              Text(
                                "Stock:",
                                style: kButtonDarkTextStyle,
                              ),
                              Text(
                                "${_product.stocks}",
                                style: kButtonLightTextStyle,
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: Dimen.regularPadding,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              "Seller:",
                              style: kButtonLightTextStyle,
                            ),
                            isSellerActive
                                ? OutlinedButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) => SellerPage(
                                                  sellerID: _sellerID!)));
                                    },
                                    child: Text(
                                      _product.seller,
                                      style: const TextStyle(
                                          color: AppColors.secondary,
                                          fontSize: 18),
                                    ),
                                  )
                                : Text(
                                    _product.seller,
                                    style: const TextStyle(
                                        color: AppColors.secondary,
                                        fontSize: 18),
                                  ),
                          ],
                        ),
                        buyWidget(context, widget.productID, _product.stocks),
                      ],
                    ),
                  ),
                  Container(
                      padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
                      child: const Text(
                        "Description:",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                        ),
                      )),
                  Container(
                    padding: Dimen.regularPadding,
                    child: Text(
                      _product.desc,
                      style: const TextStyle(color: Colors.black),
                      textAlign: TextAlign.left,
                      //details
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton.icon(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => Reviews(
                                          productID: widget.productID,
                                        )));
                          },
                          icon: const Icon(
                            Icons.comment,
                            color: AppColors.secondary,
                          ),
                          label: const Text(
                            "See Reviews",
                            style: TextStyle(
                                color: AppColors.secondary, fontSize: 18),
                          )),
                    ],
                  ),
                ],
              ),
            );
          }),
      backgroundColor: const Color.fromRGBO(235, 235, 235, 1.0),
    );
  }
}

buyWidget(context, productID, stocks) {
  if (stocks > 0) {
    return OutlinedButton.icon(
        onPressed: () async {
          if (await Basket.isInBasket(productID)) {
            showDialog(
                context: context,
                builder: (_) => AlertDialog(
                      title: const Text("Already Added"),
                      content:
                          const Text("This product is already in your basket"),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(_);
                            },
                            child: const Text("Ok"))
                      ],
                    ));
          } else {
            Basket.addItem(productID);
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
        icon: const Icon(
          Icons.shopping_cart,
          color: AppColors.secondary,
        ),
        label: const Text(
          "Add to Basket",
          style: TextStyle(color: AppColors.secondary, fontSize: 18),
        ));
  }
  return Container(
      padding: Dimen.smallPadding,
      decoration: BoxDecoration(
        border: Border.all(width: 1),
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      child: Text(
        "Out of stock",
        style: TextStyle(color: AppColors.notification, fontSize: 18),
      ));
}
