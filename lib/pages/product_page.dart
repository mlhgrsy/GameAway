import 'package:flutter/material.dart';
import 'package:gameaway/services/db.dart';
import 'package:gameaway/services/util.dart';
import 'package:gameaway/utils/colors.dart';
import 'package:gameaway/utils/dimensions.dart';
import 'package:gameaway/utils/styles.dart';
import 'package:gameaway/views/action_bar.dart';
import 'package:gameaway/views/product_preview.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key, required this.productID}) : super(key: key);
  final String productID;

  @override
  State<ProductPage> createState() => _ProductPage();
}

class _ProductPage extends State<ProductPage> {
  DBService db = DBService();
  String? productCategory;
  String? productName;
  String? productPicture;
  String? productSeller;
  double productRating = 0;
  num productPrice = 0;
  num productStocks = 0;
  String? productTag;

  Product _product = Product(
      pid: "1231232312",
      productName: "Left 4 Dead 2",
      rating: 4.5,
      price: 12.99,
      seller: "Seller2",
      url: "https://icons.iconarchive.com/icons/3xhumed/mega-games-pack-34/128/GTA-IV-Lost-and-Damned-6-icon.png",
      category: "Games",
      stocks:1,
      tag: "All"
);


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("${_product.productName}"),
      ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
        Row(
            children: [
                Container(
                  padding:Dimen.regularPadding,
                  child: CircleAvatar(
                    radius: 35,
                    backgroundImage:
                        NetworkImage(_product.url), //burası pp widget fnc yazılacak
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                SizedBox(
                  width: 200,
                  height: 55,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Price: ${_product.price}\$",
                        style: kButtonDarkTextStyle,
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
                          Text(
                            "Seller: ${_product.seller}",
                            style: kButtonDarkTextStyle,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            "Seller Rating: ${_product.seller}",
                            style: kButtonDarkTextStyle,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            "Category: ${_product.category}",
                            style: kButtonDarkTextStyle,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            "Tag: ${_product.tag}",
                            style: kButtonDarkTextStyle,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            "Stock: ${_product.stocks}",
                            style: kButtonDarkTextStyle,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            "Description:",
                            style: kButtonDarkTextStyle,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        OutlinedButton.icon(
                            onPressed: () {
                              Navigator.pushNamed(context, "homepage/explore")
                                  .then((value) {
                                setState(() {});
                              });
                            },
                            icon: const Icon(Icons.shopping_cart),
                            label: const Text("Add to Cart")),
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
                    "Lorem ipsum",
                    style: kButtonDarkTextStyle,
                    overflow: TextOverflow.ellipsis,
                    textAlign:TextAlign.left,
                     //details
                  ),
                )
      ],
            ),
          ),
      backgroundColor: AppColors.primary,
    );
  }
}
