import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gameaway/pages/product_page.dart';
import 'package:gameaway/utils/colors.dart';
import 'package:gameaway/utils/dimensions.dart';
import 'package:gameaway/utils/styles.dart';
import 'package:gameaway/views/edit_product.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'delete_product.dart';

class ProductPreview extends StatefulWidget {
  const ProductPreview({
    Key? key,
    required this.product,
    this.refreshFunc,
    this.editable = false,
  }) : super(key: key);

  final Product product;
  final Function? refreshFunc;
  final bool editable;

  @override
  State<ProductPreview> createState() => _ProductPreviewState();
}

class _ProductPreviewState extends State<ProductPreview> {
  void childRefreshFunc() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (context, AsyncSnapshot prefs) {
          if (!prefs.hasData) return const Text("Loading...");
          return OutlinedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith(
                    (states) => AppColors.primary.withOpacity(0.1)),
                shape: MaterialStateProperty.resolveWith((states) =>
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                padding: MaterialStateProperty.resolveWith(
                    (states) => EdgeInsets.zero)),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ProductPage(
                        productID: widget.product.pid,
                        refreshFunc: childRefreshFunc,
                      )));
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Stack(
                  alignment: Alignment.topRight,
                  children: <Widget>[
                    Column(
                      children: [
                        Container(
                          width: 150,
                          padding: Dimen.smallPadding,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.network(
                                widget.product.url,
                                height: 150,
                                width: 75,
                              ),
                              SizedBox(
                                height: 30,
                                child: Text(
                                  widget.product.productName,
                                  style: kSmallTitle,
                                ),
                              ),
                              Text(
                                widget.product.seller,
                                style: kSmallText,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              RatingBarIndicator(
                                rating: widget.product.rating as double,
                                itemBuilder: (context, index) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                itemCount: 5,
                                itemSize: 18.0,
                                unratedColor: Colors.amber.withAlpha(80),
                                direction: Axis.horizontal,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text("\$ ${widget.product.price}")
                            ],
                          ),
                        )
                      ],
                    ),
                    ...(!widget.editable
                        ? [
                            IconButton(
                                onPressed: () {
                                  if (prefs.data!.getStringList("favorites") ==
                                      null) {
                                    setState(() {
                                      prefs.data!.setStringList(
                                          "favorites", [widget.product.pid]);
                                    });
                                  } else if (prefs.data!
                                      .getStringList("favorites")!
                                      .contains(widget.product.pid)) {
                                    var temp =
                                        prefs.data!.getStringList("favorites")!;
                                    temp.remove(widget.product.pid);
                                    setState(() {
                                      prefs.data!
                                          .setStringList("favorites", temp);
                                    });
                                  } else {
                                    var temp =
                                        prefs.data!.getStringList("favorites")!;
                                    temp.add(widget.product.pid);
                                    setState(() {
                                      prefs.data!
                                          .setStringList("favorites", temp);
                                    });
                                  }
                                  if (widget.refreshFunc != null) {
                                    widget.refreshFunc!();
                                  }
                                },
                                icon: Icon(
                                    prefs.data!.getStringList("favorites") ==
                                                null ||
                                            !prefs.data!
                                                .getStringList("favorites")
                                                .contains(widget.product.pid)
                                        ? Icons.favorite_outline
                                        : Icons.favorite, color:AppColors.notification))
                          ]
                        : editableButtons(
                            context, widget.product, widget.refreshFunc)),
                  ],
                ),
                Visibility(
                    visible: widget.product.stocks <= 0,
                    child: const Text(
                      "Out of Stock",
                      style: TextStyle(color: AppColors.notification),
                    ))
              ],
            ),
          );
        });
  }
}

List<Widget> editableButtons(context, product, refreshFunc) {
  return <Widget>[
    Positioned(
      top: 0,
      left: 0,
      child: IconButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => EditProduct(
                        product: product, refreshFunc: refreshFunc)));
          },
          icon: const Icon(Icons.edit)),
    ),
    Positioned(
        top: 0,
        right: 0,
        child: IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => DeleteProduct(
                      pid: product.pid, refreshFunc: refreshFunc));
            },
            icon: const Icon(Icons.delete))),
  ];
}

class Product {
  String pid;
  String url;
  String productName;
  String seller;
  num rating;
  num price;
  num stocks;
  String category;
  String tag;
  String desc;


  Product({required this.pid,
    required this.url,
    required this.productName,
    required this.rating,
    required this.price,
    required this.stocks,
    this.desc = "No Description",
    this.category = "Games",
    this.tag = "All",
    this.seller = "Anonymous",
  });
}
