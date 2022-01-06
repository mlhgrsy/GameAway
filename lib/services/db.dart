import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gameaway/utils/colors.dart';
import 'package:gameaway/utils/dimensions.dart';
import 'package:gameaway/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:gameaway/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';

import 'order.dart';

CollectionReference users = _firestore.collection('Users');
FirebaseFirestore _firestore = FirebaseFirestore.instance;
FirebaseAuth auth = FirebaseAuth.instance;
var email = auth.currentUser!.uid;
var loguser = users.doc(email);
var response = loguser.get();
var notify = loguser.collection("notification");

class DBService {
  final CollectionReference notifiaca =
      FirebaseFirestore.instance.collection("notifications");

  static final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('Users');

  static DocumentReference getUserReference(String id) {
    return FirebaseFirestore.instance.collection("Users").doc(id);
  }

  static DocumentReference getProductReference(String id) {
    return FirebaseFirestore.instance.collection("product").doc(id);
  }

  static final CollectionReference ordersCollection =
      FirebaseFirestore.instance.collection("order");

  static Future addUser(String uid, bool hasProvider, String name) async {
    await userCollection.doc(uid).set({
      'has_provider': hasProvider,
      'name': name,
      'pp':
          "https://ih1.redbubble.net/image.1046392278.3346/pp,840x830-pad,1000x1000,f8f8f8.jpg",
      'rating': 0
    });
  }

  static Future updatePP(String uid, String newURL) async {
    await userCollection.doc(uid).update({'pp': newURL});
  }

  static Future updateMail(String uid, String newMail) async {
    await userCollection.doc(uid).update({'email': newMail});
  }

  static Future updateName(String uid, String newName) async {
    await userCollection.doc(uid).update({'name': newName});
  }

  static Future hasProvider(String uid) async {
    return (await userCollection.doc(uid).get())["has_provider"];
  }

  static Future deleteAccount(String uid) async {
    final userRef = getUserReference(uid);
    var sellQuery =
        await productCollection.where("seller", isEqualTo: userRef).get();
    for (var element in sellQuery.docs) {
      await element.reference.update({"stocks": 0});
    }
    await userRef.update({"name": "[Deleted User]"});
  }

  static final CollectionReference productCollection =
      FirebaseFirestore.instance.collection('product');

  Future addProduct(
      String category,
      String name,
      num price,
      DocumentReference seller,
      String tag,
      File picture,
      num stocks,
      String desc) async {
    var productRef = await productCollection.add({
      'category': category,
      'name': name,
      'picture': "",
      'price': price,
      'rating': [],
      'seller': seller,
      'tag': tag,
      'stocks': stocks,
      'reviews': [],
      'desc': desc
    });

    var ref = FirebaseStorage.instance.ref();
    String filepath =
        "/productImages/${productRef.id}${extension(picture.path)}";
    await ref.child(filepath).putFile(picture);
    String productPictureURL = await ref.child(filepath).getDownloadURL();
    await productRef.update({"picture": productPictureURL});
  }

  Future editProduct(String id, String category, String name, num price,
      String tag, File? picture, num stocks, String desc) async {
    var productRef = productCollection.doc(id);
    if (picture == null) {
      productRef.update({
        'category': category,
        'name': name,
        'price': price,
        'tag': tag,
        'stocks': stocks,
        'desc': desc
      });
    } else {
      String oldURL = (await productRef.get()).get("picture");
      var ref = FirebaseStorage.instance.refFromURL(oldURL);
      await ref.delete();
      await ref.putFile(picture);
      String productPictureURL = await ref.getDownloadURL();
      await productRef.update({
        'category': category,
        'name': name,
        'price': price,
        'tag': tag,
        'stocks': stocks,
        "picture": productPictureURL,
        'desc': desc
      });
    }
  }

  Future deleteProduct(String pid) async {
    var productRef = productCollection.doc(pid);
    var pictureRef = FirebaseStorage.instance
        .refFromURL((await productRef.get()).get("picture"));
    await pictureRef.delete();
    await productRef.delete();
  }

  Future addReview(Order order, num rating, String comment) async {
    await ordersCollection.doc(order.oid).update({"reviewed": true});
    var buyerRef = (await ordersCollection.doc(order.oid).get()).get("buyer");
    var sellerRef = (await ordersCollection.doc(order.oid).get()).get("seller");
    if (comment.trim() == "") {
      await productCollection.doc(order.pid).update({
        "rating": FieldValue.arrayUnion([rating])
      });
    } else {
      await productCollection.doc(order.pid).update({
        "rating": FieldValue.arrayUnion([rating]),
        "reviews": FieldValue.arrayUnion([
          {
            "approved": false,
            "comment": comment,
            "rating": rating,
            "reviewer": buyerRef,
            "seller": sellerRef
          }
        ])
      });
    }
  }

  Future addnotif(String notif) async {
    notify
        .add({
          'notify': notif,
        })
        .then((value) => print('notification added'))
        .catchError((error) => print('Error: ${error.toString()}'));
  }
}
