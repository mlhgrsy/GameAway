import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:gameaway/pages/homepage/homepage.dart';
import 'package:gameaway/pages/profile.dart';
import 'package:gameaway/pages/sell_product.dart';
import 'package:gameaway/pages/sign_in.dart';
import 'package:gameaway/pages/suggestions.dart';
import 'package:gameaway/services/bottom_nav.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/basket.dart';
import 'pages/favorites.dart';

class Root extends StatefulWidget {
  const Root({Key? key, required this.analytics, required this.observer})
      : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  var routes = [
    const HomePage(),
    const Basket(),
    const Favorites(),
    const Suggestions(),
    SellProduct(),
    const Profile()
  ];

  Future<void> walk() async {
    final prefs = await SharedPreferences.getInstance();
    print(prefs.getBool('walked'));
    // set value
    if (prefs.getBool('walked') == false || prefs.getBool('walked') == null) {
      prefs.setBool('walked', true);
      Navigator.pushNamed(context, '/walk');
    }
  }

  @override
  void initState() {
    super.initState();
    _sendAnalyticsEvent();
    walk();

    // FirebaseCrashlytics.instance.crash();
    // obtain shared preferences
  }

  Future<void> _sendAnalyticsEvent() async {
    await widget.analytics.setCurrentScreen(screenName: "Root Page");
    // await widget.analytics.logEvent(
    //   name: 'test_event',
    //   parameters: <String, dynamic>{
    //     'testParam': 'testing',
    //   },
    // );
  }

  //BottomNavigation

  void _onBottomTabPress(int index) {
    bool isSignedIn = null != Provider.of<User?>(context, listen: false);
    if (!isSignedIn && index == 5) {
      Navigator.pushNamed(context, "/signIn");
    } else {
      Provider.of<BottomNav>(context,listen: false).switchTo(index);
      widget.analytics.setCurrentScreen(screenName: routes[index].toString());
    }
  }

  @override
  Widget build(BuildContext context) {

    int currentNavIndex = Provider.of<BottomNav>(context).index;

    return Scaffold(
      body: routes[currentNavIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.green),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_basket),
              label: 'Basket',
              backgroundColor: Colors.green),
          BottomNavigationBarItem(
              icon: Icon(Icons.star),
              label: 'Favorites',
              backgroundColor: Colors.green),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Suggestions',
              backgroundColor: Colors.green),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_shopping_cart),
              label: 'Sell Product',
              backgroundColor: Colors.green),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Profile',
              backgroundColor: Colors.green)
        ],
        currentIndex: currentNavIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onBottomTabPress,
      ),
    );
  }
}
