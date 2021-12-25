import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gameaway/utils/colors.dart';
import 'package:gameaway/utils/dimensions.dart';
import 'package:gameaway/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:gameaway/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
CollectionReference users= _firestore.collection('Users');
FirebaseFirestore _firestore= FirebaseFirestore.instance;
FirebaseAuth auth= FirebaseAuth.instance;
var email= auth.currentUser!.email;
var loguser =users.doc(email);
var response =  loguser.get();
var notify =loguser.collection("notifications");
class DBService {
  final CollectionReference notifiaca= FirebaseFirestore.instance.collection("notifications");
  Future addnotif(String notif) async {

    notify.add({
      'notify': notif,
    })
        .then((value) => print('notification added'))
        .catchError((error) => print('Error: ${error.toString()}'));
  }



}