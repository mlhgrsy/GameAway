import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:gameaway/pages/homepage.dart';
import 'package:gameaway/pages/profile.dart';
import 'package:gameaway/pages/sell_product.dart';
import 'package:gameaway/pages/sign_in.dart';
import 'package:gameaway/pages/suggestions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/basket.dart';
import 'pages/favorites.dart';


class Root extends StatefulWidget {
  const Root({Key? key}) : super(key: key);

  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  var routes = [
    const HomePage(),
    const Basket(),
    const Favorites(),
    const Suggestions(),
    const SellProduct(),
    const SignIn()
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
    walk();
    //FirebaseCrashlytics.instance.crash();
    // obtain shared preferences
  }

  //BottomNavigation
  static int _selectedBottomTabIndex = 0;

  void _onBottomTabPress(int index) {
    setState(() {
      _selectedBottomTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.notifications,
                color: Colors.red,
                size: 40,
              ))
        ],
        title: const Text(
          'GameAway',
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
        elevation: 0.0,
      ),
      body: routes[_selectedBottomTabIndex],
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
        currentIndex: _selectedBottomTabIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onBottomTabPress,
      ),
    );
  }
}
