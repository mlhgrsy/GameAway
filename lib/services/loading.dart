import 'package:flutter/foundation.dart';

class Loading with ChangeNotifier {
  Loading();

  int queue = 0;

  bool get isLoading {
    return queue != 0;
  }

  void increment() {
    queue++;
    notifyListeners();
  }

  void decrement() {
    queue--;
    notifyListeners();
  }
}
