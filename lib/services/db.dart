import 'package:cloud_firestore/cloud_firestore.dart';

class DBService {
  static final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('Users');

  static Future addUser(String uid, bool hasProvider) async {
    userCollection.doc(uid).set({'has_provider': hasProvider});
  }
}
