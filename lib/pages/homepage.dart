import 'package:flutter/material.dart';
import 'package:gameaway/utils/colors.dart';
import 'package:gameaway/utils/dimensions.dart';
import 'package:gameaway/utils/styles.dart';
import 'package:gameaway/views/product_preview.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  //Categories
  static final _categories = [
    "Games",
    "Board Games",
    "Hardware",
    "Accounts",
    "Boost"
  ];
  static int _currentCategory = 0;

  //DropDown
  static String _dropdownValue = 'All';
  static final _dropdownItemsString = [
    <String>['All', 'Horror', 'RPG', 'Shooters', "Sandbox", "Open World", "Others"],
    <String>['All', 'Abstract', 'Area Control', 'Campaign', "Deckbuilder", "Drafting","Dungeon-crawler","Others"],
    <String>['All', "PC", "XBOX", "PlayStation", "Nintendo", "Atari", "Others"],
    <String>['All', 'Steam', 'Epic Games', 'Uplay', "Battle.net", "Origin", "Others"],
    <String>['All', 'Ranking', 'Achievement', 'Level',"Others"]
  ];
  static final _dropdownItems = _dropdownItemsString
      .map((e) => e.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList())
      .toList();

  //ProductPreview
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(children: [
              Expanded(child: TextFormField()),
              IconButton(onPressed: () {}, icon: Icon(Icons.search))
            ]),
            SizedBox(
              height: 60,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: List.generate(_categories.length, (int index) {
                  return OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _currentCategory = index;
                        _dropdownValue =
                            _dropdownItemsString[_currentCategory][0];
                      });
                    },
                    child: Container(
                      height: 50.0,
                      child: Text(_categories[index]),
                    ),
                  );
                }),
              ),
            ),
            Container(
              padding:EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(color: AppColors.headingColor.withAlpha(50),),
              width: 200,
              child: DropdownButton(
                isExpanded: true,
                dropdownColor: AppColors.headingColor.withAlpha(250),
                items: _dropdownItems[_currentCategory],
                value: _dropdownValue,
                onChanged: (String? newValue) {
                  setState(() {
                    _dropdownValue = newValue!;
                  });
                },
              ),
            ),
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
                            SizedBox(width: 8)
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
                            SizedBox(width: 8)
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
