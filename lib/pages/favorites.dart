import 'package:flutter/material.dart';
import 'package:gameaway/services/db.dart';
import 'package:gameaway/services/util.dart';
import 'package:gameaway/views/action_bar.dart';
import 'package:gameaway/views/product_preview.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Favorites extends StatefulWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  Future<List<Product>> getFavorites() async {
    DBService db = DBService();
    var favoritesList =
        (await SharedPreferences.getInstance()).getStringList("favorites");
    if (favoritesList == null || favoritesList.isEmpty) {
      return <Product>[];
    } else {
      List<Product> favoriteProducts = <Product>[];
      for (var i = 0; i < favoritesList.length; i++) {
        var currentSnapshot =
            await db.productCollection.doc(favoritesList[i]).get();
        var currentProduct = Product(
            pid: favoritesList[i],
            url: currentSnapshot.get("picture"),
            productName: currentSnapshot.get("name"),
            rating: Util.avg(currentSnapshot.get("rating")),
            price: currentSnapshot.get("price"));
        favoriteProducts.add(currentProduct);
      }
      return favoriteProducts;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ActionBar(title: "Favorites"),
      body: FutureBuilder(
          future: getFavorites(),
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return const Text("Loading...");
            } else if (snapshot.data.isEmpty) {
              return const Center(
                  child:
                      Text("You have no favorite products. Try adding some!"));
            }
            List<Product> favoritesList = snapshot.data;
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: GridView.count(
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: .6,
                  crossAxisCount: 2,
                  children: List.generate(
                      favoritesList.length,
                      (index) =>
                          ProductPreview(product: favoritesList[index]))),
            );
          }),
    );
  }
}
