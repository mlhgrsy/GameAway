import 'package:flutter/material.dart';
import 'package:gameaway/views/action_bar.dart';
import 'package:gameaway/views/category_tag_selection.dart';

class Explore extends StatefulWidget {
  const Explore({Key? key}) : super(key: key);

  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ActionBar(),
      body: SingleChildScrollView(
        child: Column(
          children: const [CategoryTagSelection()],
        ),
      ),
    );
  }
}
