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

  static DocumentReference getSellerReference(String id) {
    return FirebaseFirestore.instance.collection("Users").doc(id);
  }

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
    return (await userCollection.doc(uid).delete());
  }

  final CollectionReference productCollection =
      FirebaseFirestore.instance.collection('product');

  Future addProduct(String category, String name, num price,
      DocumentReference seller, String tag, File picture) async {
    var productRef = await productCollection.add({
      'category': category,
      'name': name,
      'picture': "",
      'price': price,
      'rating': [],
      'seller': seller,
      'tag': tag,
    });

    var ref = FirebaseStorage.instance.ref();
    String filepath =
        "/productImages/${productRef.id}${extension(picture.path)}";
    await ref.child(filepath).putFile(picture);
    String productPictureURL = await ref.child(filepath).getDownloadURL();
    await productRef.update({"picture": productPictureURL});
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
