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
}
