import 'package:gameaway/views/product_preview.dart';

class Util {
  static double avg(List<dynamic> list) {
    if (list.isEmpty) return 0;
    return double.parse(
        (list.reduce((a, b) => a + b) / list.length).toStringAsFixed(1));
  }

  static final categories = [
    "Games",
    "Board Games",
    "Hardware",
    "Accounts",
    "Boost"
  ];

  static final tags = [
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

  static final sortTypes = ["name", "rating", "price"];
  static final sortFuncs = <String, Map<bool, int Function(Product, Product)>>{
    "name": {
      true: (Product a, Product b) =>
          a.productName.toLowerCase().compareTo(b.productName.toLowerCase()),
      false: (Product b, Product a) =>
          a.productName.toLowerCase().compareTo(b.productName.toLowerCase())
    },
    "rating": {
      true: (Product a, Product b) => a.rating.compareTo(b.rating),
      false: (Product b, Product a) => a.rating.compareTo(b.rating)
    },
    "price": {
      true: (Product a, Product b) => a.price.compareTo(b.price),
      false: (Product b, Product a) => a.price.compareTo(b.price)
    },
  };
}
