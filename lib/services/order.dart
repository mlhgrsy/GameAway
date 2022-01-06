import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  String oid;
  String url;
  String productName;
  String pid;
  num price;
  bool reviewed;
  Timestamp purchaseDate;
  String buyer;

  Order(
      {required this.url,
      required this.oid,
      required this.productName,
      required this.pid,
      required this.price,
      required this.purchaseDate,
      this.reviewed = false,
      this.buyer = "Anonymous"});
}
