import 'package:flutter/material.dart';
import 'package:gameaway/services/db.dart';
import 'package:gameaway/utils/dimensions.dart';
import 'package:gameaway/utils/styles.dart';
import 'package:gameaway/views/action_bar.dart';
import 'package:gameaway/views/category_tag_selection.dart';
import 'package:gameaway/views/product_preview.dart';

class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  @override
  Widget build(BuildContext context) {
    DBService db = DBService();
    return Scaffold(
      appBar: ActionBar(),
      body: FutureBuilder(
          future: db.productCollection.get(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) return const Text("Loading...");
            var _products = snapshot.data.docs
                .map<Product>((doc) => Product(
                    price: doc.data()['price'],
                    productName: doc.data()['name'],
                    category: doc.data()['category'],
                    tag: doc.data()['tag'],
                    seller: doc.data()['seller'],
                    url: doc.data()['picture'],
                    rating: doc.data()['rating']))
                .toList();
            final _promotions =
                _products.where((p) => (p.price < 100) as bool).toList();
            final _recommendations =
                _products.where((p) => (p.rating >= 4.5) as bool).toList();
            return SingleChildScrollView(
              child: Column(
                children: [
                  OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(
                            context, "homepage/explore"); //homepage/explore
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
                            _promotions.length,
                            (index) => Row(children: [
                                  productPreview(_promotions[index]),
                                  const SizedBox(width: 8)
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
                            _recommendations.length,
                            (index) => Row(children: [
                                  productPreview(_recommendations[index]),
                                  const SizedBox(width: 8)
                                ])),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
