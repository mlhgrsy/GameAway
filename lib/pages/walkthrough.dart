import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:gameaway/utils/colors.dart';
import 'package:gameaway/utils/dimensions.dart';
import 'package:gameaway/utils/styles.dart';

class WalkThrough extends StatefulWidget {
  const WalkThrough({Key? key}) : super(key: key);

  @override
  State<WalkThrough> createState() => _WalkThroughState();
}

class _WalkThroughState extends State<WalkThrough> {
  List<String> title = [
    "WELCOME",
    "HOME",
    "BASKET",
    "FAVORITES",
    "SELL PRODUCT",
    "PROFILE",
  ];

  List<String> heading = [
    "What is GameAway?",
    "Browsing Game Stuffs",
    "Add Products into Basket ",
    "Make Favorite Lists",
    "Sell the Game Stuff Here!",
    "Customize the Profile ",
  ];

  List<String> images = [
    "assets/walk_images/gameaway logo.png",
    "assets/walk_images/home.png",
    "assets/walk_images/basket.png",
    "assets/walk_images/fav.png",
    "assets/walk_images/sell.png",
    "assets/walk_images/profile.png",
  ];

  List<String> captions = [
    "All about the game marketing is here. Search, buy and sell anything related with games.",
    "See the trending game sales. Search and sort among all products.",
    "List the products added in the basket.",
    "List your favorite products, and sellers.",
    "Sell your products easily. Also see your selling list.",
    "Sign up to see your settings, history and notifications.",
  ];

  int currentPage = 0;
  int lastPage = 5;

  void nextPage() {
    if (currentPage < lastPage) {
      setState(() {
        currentPage += 1;
      });
    }
  }

  void prevPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage -= 1;
      });
    }
  }

  void skipPage() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          OutlinedButton(
              child: const Text(
                "Close",
                style: TextStyle(color: AppColors.notification),
              ),
              onPressed: skipPage),
        ],
        backgroundColor: AppColors.primaryBackground,
        title: Text(title[currentPage], style: kAppBarTitleTextStyle),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Text(heading[currentPage],
                  textAlign: TextAlign.center, style: kHeadingTextStyle),
            ),
          ),
          Container(
            height: 300,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Image(
              image: AssetImage(images[currentPage]),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Center(
              child: Text(captions[currentPage],
                  textAlign: TextAlign.center, style: kButtonLightTextStyle),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Container(
              child: Row(
                children: [
                  OutlinedButton(
                      child: const Icon(Icons.arrow_left,
                          color: AppColors.primary),
                      onPressed: prevPage),
                  Spacer(),
                  AnimatedSmoothIndicator(
                    activeIndex: currentPage,
                    count: 6,
                    effect: const ExpandingDotsEffect(
                      dotColor: AppColors.primary,
                      activeDotColor: AppColors.primaryBackground,
                    ),
                  ),
                  Spacer(),
                  OutlinedButton(
                      child: Icon(
                        Icons.arrow_right,
                        color: AppColors.primary,
                      ),
                      onPressed: nextPage),
                ],
              ),
              height: 80,
            ),
          ),
        ],
      )),
    );
  }
}
