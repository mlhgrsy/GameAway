import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gameaway/services/db.dart';
import 'package:gameaway/utils/colors.dart';
import 'package:gameaway/views/product_preview.dart';

class CategoryTagSelection extends StatefulWidget {
  const CategoryTagSelection({Key? key}) : super(key: key);

  @override
  _CategoryTagSelectionState createState() => _CategoryTagSelectionState();
}

class _CategoryTagSelectionState extends State<CategoryTagSelection> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
      'Shooter',
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
  DBService db = DBService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
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
          final resultList = _products
              .where((p) =>
                  p.category == _categories[_currentCategory] &&
                  (_dropdownValue == "All" || p.tag == _dropdownValue))
              .toList();
          return Column(
            children: [
              Column(children: [
                OutlinedButton.icon(
                    onPressed: () {
                      showSearch(
                          context: context,
                          delegate: DataSearch(
                            products: _products,
                          ));
                    },
                    label: const Text("Search Anything"),
                    icon: const Icon(Icons.search)),
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
              ),
              SizedBox(
                height: 400,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: GridView.count(
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: .5,
                      crossAxisCount: 2,
                      children: List.generate(resultList.length,
                          (index) => productPreview(resultList[index]))),
                ),
              ),
            ],
          );
        });
  }
}

class DataSearch extends SearchDelegate<String> {
  final List<Product> products;

  DataSearch({required this.products});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, '');
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    final resultList =
        products.where((p) => p.productName.startsWith(query)).toList();
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: GridView.count(
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: .5,
          crossAxisCount: 2,
          children: List.generate(
              resultList.length, (index) => productPreview(resultList[index]))),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList =
        products.where((p) => p.productName.startsWith(query)).toList();

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          showResults(context);
        },
        title: RichText(
            text: TextSpan(
                text: suggestionList[index]
                    .productName
                    .substring(0, query.length),
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                children: [
              TextSpan(
                  text:
                      suggestionList[index].productName.substring(query.length),
                  style: TextStyle(color: Colors.grey))
            ])),
      ),
      itemCount: suggestionList.length,
    );
  }
}
