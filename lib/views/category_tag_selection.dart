import 'package:flutter/material.dart';
import 'package:gameaway/utils/colors.dart';
import 'package:gameaway/views/product_preview.dart';

class CategoryTagSelection extends StatefulWidget {
  const CategoryTagSelection({Key? key}) : super(key: key);

  @override
  _CategoryTagSelectionState createState() => _CategoryTagSelectionState();
}

class _CategoryTagSelectionState extends State<CategoryTagSelection> {
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
    <String>[
      'All',
      'Horror',
      'RPG',
      'Shooters',
      "Sandbox",
      "Open World",
      "Others"
    ],
    <String>[
      'All',
      'Abstract',
      'Area Control',
      'Campaign',
      "Deckbuilder",
      "Drafting",
      "Dungeon-crawler",
      "Others"
    ],
    <String>['All', "PC", "XBOX", "PlayStation", "Nintendo", "Atari", "Others"],
    <String>[
      'All',
      'Steam',
      'Epic Games',
      'Uplay',
      "Battle.net",
      "Origin",
      "Others"
    ],
    <String>['All', 'Ranking', 'Achievement', 'Level', "Others"]
  ];
  static final _dropdownItems = _dropdownItemsString
      .map((e) => e.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList())
      .toList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [
          Expanded(child: TextFormField()),
          IconButton(icon: Icon(Icons.search), onPressed: () {
            showSearch(context: context, delegate: DataSearch());
          },)
        ]),
        SizedBox(
          height: 60,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: List.generate(_categories.length, (int index) {
              return OutlinedButton(
                style: ButtonStyle(backgroundColor:
                    MaterialStateProperty.resolveWith<Color?>((states) {
                  if (states.contains(MaterialState.pressed)) {
                    return AppColors.background.withOpacity(.5);
                  } else if (_currentCategory == index) {
                    return AppColors.background;
                  } else {
                    return null;
                  }
                }), foregroundColor:
                    MaterialStateProperty.resolveWith<Color?>((states) {
                  return (_currentCategory == index)
                      ? AppColors.DarkTextColor
                      : AppColors.LightTextColor;
                })),
                onPressed: () {
                  setState(() {
                    _currentCategory = index;
                    _dropdownValue = _dropdownItemsString[_currentCategory][0];
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
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: AppColors.headingColor.withAlpha(50),
          ),
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
        )
      ],
    );
  }
}


class DataSearch extends SearchDelegate<String>{

  final Products = [
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

  final recentProducts= [
    Product(
        url:
        "https://icons.iconarchive.com/icons/3xhumed/mega-games-pack-34/128/GTA-IV-Lost-and-Damned-6-icon.png",
        productName: "GTA IV",
        rating: 4.7,
        price: 179.99,
        seller: "Seller1"),
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
  List<Widget>? buildActions(BuildContext context) {
    return [IconButton(icon: Icon(Icons.clear),onPressed: (){
      query = "";
    })];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: (){
          close(context,'');
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      child: Center(
        child: productPreview(Products[0]) // dUzeltme gerek dUzeltme gerek dUzeltme gerek dUzeltme gerek dUzeltme gerek
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty?recentProducts
        :Products.where((p) => p.productName.startsWith(query)).toList();

    return ListView.builder(itemBuilder: (context,index)=>ListTile(
      onTap: (){
        showResults(context);
      },
      title:RichText(text:TextSpan(
        text: suggestionList[index].productName.substring(0,query.length),
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        children: [TextSpan(
          text:suggestionList[index].productName.substring(query.length),
          style: TextStyle(color: Colors.grey)
        )]
      )),
    ),
      itemCount: suggestionList.length,
    );
  }

}
