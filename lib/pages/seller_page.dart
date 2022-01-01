import 'package:flutter/material.dart';
import 'package:gameaway/services/db.dart';
import 'package:gameaway/utils/colors.dart';
import 'package:gameaway/views/action_bar.dart';
import 'package:gameaway/views/product_preview.dart';

class SellerPage extends StatefulWidget {
  const SellerPage({Key? key, required this.sellerID}) : super(key: key);
  final String sellerID;

  @override
  State<SellerPage> createState() => _SellerPageState();
}

class _SellerPageState extends State<SellerPage> {
  DBService db = DBService();
  String? sellerName;
  List<Product>? _resultList;
  List<Product>? _products;

  Future<void> getProducts() async {
    var sellerReference = DBService.getSellerReference(widget.sellerID);
    final seller = await sellerReference.get();
    sellerName = seller["name"];
    var r = await db.productCollection
        .where("seller", isEqualTo: sellerReference)
        .get();
    var _productsTemp = r.docs
        .map<Product>((doc) => Product(
            price: doc['price'],
            productName: doc['name'],
            category: doc['category'],
            tag: doc['tag'],
            seller: sellerName ?? "Unknown Seller",
            url: doc['picture'],
            rating: doc['rating']))
        .toList();
    print(_productsTemp);
    setState(() {
      _resultList = _productsTemp;
    });
  }

  @override
  void initState() {
    super.initState();
    getProducts();
  }

  @override
  Widget build(BuildContext context) {
    if (_resultList == null) return const Text("Loading...");
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(sellerName!),
          backgroundColor: AppColors.primaryBackground,
          centerTitle: true,
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
                  childAspectRatio: .5,
                  crossAxisCount: 2,
                  children: List.generate(_resultList!.length,
                      (index) => productPreview(_resultList![index]))),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: GridView.count(
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: .5,
                  crossAxisCount: 2,
                  children: List.generate(_resultList!.length,
                      (index) => productPreview(_resultList![index]))),
            )
          ],
        ),
      ),
    );
  }
}
