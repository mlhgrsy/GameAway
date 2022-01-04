import 'package:gameaway/views/product_preview.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Basket {
  static createBasket(instance) {
    if (instance.getStringList("basket") == null) {
      instance.setStringList("basket", <String>[]);
    }
  }

  static Future<List<String>?> getItems() async {
    var instance = await SharedPreferences.getInstance();
    createBasket(instance);
    return instance.getStringList("basket");
  }

  static Future addItem(String pid) async {
    var instance = await SharedPreferences.getInstance();
    createBasket(instance);
    var basket = instance.getStringList("basket");
    basket!.add(pid);
    instance.setStringList("basket", basket);
  }

  static Future removeItem(String pid) async {
    var instance = await SharedPreferences.getInstance();
    var basket = instance.getStringList("basket");
    basket!.remove(pid);
    instance.setStringList("basket", basket);
  }

  static Future<bool> isInBasket(String pid) async {
    var instance = await SharedPreferences.getInstance();
    createBasket(instance);
    var basket = instance.getStringList("basket");
    return basket!.contains(pid);
  }
}
