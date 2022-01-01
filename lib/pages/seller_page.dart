import 'package:flutter/material.dart';
import 'package:gameaway/services/db.dart';
import 'package:gameaway/services/util.dart';
import 'package:gameaway/utils/colors.dart';
import 'package:gameaway/views/action_bar.dart';
import 'package:gameaway/views/product_preview.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class SellerPage extends StatefulWidget {
  const SellerPage({Key? key, required this.sellerID}) : super(key: key);
  final String sellerID;

  @override
  State<SellerPage> createState() => _SellerPageState();
}

class _SellerPageState extends State<SellerPage> {
  DBService db = DBService();
  String? sellerName;
  String? sellerPP;
  double sellerRating = 0;
  List<Product>? _onSaleProducts;
  List<Product>? _soldProducts;

  Future<void> getProducts() async {
    var sellerReference = DBService.getSellerReference(widget.sellerID);
    final seller = await sellerReference.get();
    sellerName = seller["name"];
    sellerPP = seller["pp"];
    var r = await db.productCollection
        .where("seller", isEqualTo: sellerReference)
        .get();
    List<dynamic> sellerRatings = [];
    var _onSaleProductsTemp = r.docs.map<Product>((doc) {
      double productRating = Util.avg(doc['rating']);
      sellerRatings.add(productRating);
      return Product(
          price: doc['price'],
          productName: doc['name'],
          category: doc['category'],
          tag: doc['tag'],
          seller: sellerName ?? "Anonymous Seller",
          url: doc['picture'],
          rating: productRating);
    }).toList();
    sellerRating = Util.avg(sellerRatings);
    setState(() {
      _onSaleProducts = _onSaleProductsTemp;
    });
  }

  @override
  void initState() {
    super.initState();
    getProducts();
  }

  @override
  Widget build(BuildContext context) {
    if (_onSaleProducts == null || sellerName == null) {
      return const Text("Loading...");
    }
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 90,
          title: Row(
            children: [
              CircleAvatar(
                radius: 35,
                backgroundImage:
                    NetworkImage(sellerPP!), //burası pp widget fnc yazılacak
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
                      sellerName!,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RatingBarIndicator(
                          rating: sellerRating,
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
                          "$sellerRating",
                          style: const TextStyle(color: Colors.amber),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
          backgroundColor: AppColors.primary,
          elevation: 0.0,
          bottom: const TabBar(
            tabs: [
              Tab(text: "On Sale"),
              Tab(text: "Sold Before"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: GridView.count(
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 0.60,
                  crossAxisCount: 2,
                  children: List.generate(_onSaleProducts!.length,
                      (index) => productPreview(_onSaleProducts![index]))),
            ),
            const Text("daıodwapd") // Buy sell history'deki itemleri koyacaz
          ],
        ),
      ),
    );
  }
}
