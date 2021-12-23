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
          IconButton(onPressed: () {}, icon: Icon(Icons.search))
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
