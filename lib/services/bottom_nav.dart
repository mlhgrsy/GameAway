import 'package:flutter/foundation.dart';

class BottomNav with ChangeNotifier {
  BottomNav();
  int index = 0;

  void switchTo(int newIndex) {
    index = newIndex;
    notifyListeners();
  }
}
