import 'package:flutter/material.dart';
import 'package:gameaway/pages/homepage/explore.dart';
import 'package:gameaway/pages/homepage/feed.dart';
import 'package:gameaway/pages/seller_page.dart';
import 'package:gameaway/utils/colors.dart';
import 'package:gameaway/utils/dimensions.dart';
import 'package:gameaway/utils/styles.dart';
import 'package:gameaway/views/category_tag_selection.dart';
import 'package:gameaway/views/product_preview.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //ProductPreview
  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: "homepage/feed",
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case 'homepage/feed':
            builder = (BuildContext context) => const Feed();
            break;
          case 'homepage/explore':
            builder = (BuildContext context) => const Explore();
            break;
          default:
            throw Exception('Invalid route: ${settings.name}');
        }
        return MaterialPageRoute<void>(builder: builder, settings: settings);
      },
    );
  }
}
