import 'package:flutter/material.dart';
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
  static final _productPreviewList = <Product>[
    Product(
        url:
            "https://icons.iconarchive.com/icons/femfoyou/angry-birds/256/angry-bird-icon.png",
        productName: "AngryBirds",
        rating: 3.8,
        price: 25.99,
        seller: "Seller1"),
    Product(
        url:
            "https://icons.iconarchive.com/icons/3xhumed/mega-games-pack-40/128/Mafia-2-3-icon.png",
        productName: "Mafia2",
        rating: 3.9,
        price: 119.99,
        seller: "Seller2"),
    Product(
        url:
            "https://icons.iconarchive.com/icons/3xhumed/mega-games-pack-34/128/Max-Payne-3-2-icon.png",
        productName: "Max Payne 3",
        rating: 4.4,
        price: 124.99,
        seller: "Seller1"),
    Product(
        url:
            "https://icons.iconarchive.com/icons/3xhumed/mega-games-pack-31/128/Left4Dead-2-2-icon.png",
        productName: "Left 4 Dead 2",
        rating: 4.5,
        price: 12.99,
        seller: "Seller2"),
    Product(
        url:
            "https://icons.iconarchive.com/icons/3xhumed/mega-games-pack-34/128/GTA-IV-Lost-and-Damned-6-icon.png",
        productName: "GTA IV",
        rating: 4.7,
        price: 179.99,
        seller: "Seller1"),
    Product(
        url:
            "https://icons.iconarchive.com/icons/zakafein/game-pack-1/128/Minecraft-2-icon.png",
        productName: "Minecraft",
        rating: 4.9,
        price: 149.99,
        seller: "Seller2"),
    Product(
        url:
            "https://icons.iconarchive.com/icons/3xhumed/mega-games-pack-37/128/Crysis-2-3-icon.png",
        productName: "Crysis 2",
        rating: 3.7,
        price: 24.99,
        seller: "Seller1"),
    Product(
        url:
            "https://icons.iconarchive.com/icons/3xhumed/mega-games-pack-34/128/PES-2010-2-icon.png",
        productName: "PES 2010",
        rating: 4.0,
        price: 79.99,
        seller: "Seller2"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ActionBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            OutlinedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, "homepage/explore");
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
                      _productPreviewList.length,
                      (index) => Row(children: [
                            productPreview(_productPreviewList[index]),
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
                      _productPreviewList.length,
                      (index) => Row(children: [
                            productPreview(_productPreviewList[index]),
                            const SizedBox(width: 8)
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
