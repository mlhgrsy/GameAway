import 'package:cloud_firestore/cloud_firestore.dart';

class DBService {
  final CollectionReference productCollection = FirebaseFirestore.instance.collection('product');

  Future addProduct(String category, String name, String picture, double price, double rating, String seller,String tag) async{
    productCollection.add({
      'category': category,
      'name': name,
      'picture': picture,
      'price': price,
      'rating': rating,
      'seller': seller,
      'tag': tag,
    })
    .then((value)=> print('Product added'))
    .catchError((error) => print ('Error: ${error.toString()}'));
  }
}