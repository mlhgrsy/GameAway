import 'package:cloud_firestore/cloud_firestore.dart';

class DBService {
  static final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('Users');

  static Future addUser(String name, String mail, bool hasProvider) async {
    userCollection.doc(mail).set({
      'name': name, // First name + Last name
      'email': mail,
      'picture_url': "https://i.ytimg.com/vi/tZp8sY06Qoc/maxresdefault.jpg",
      'has_provider': hasProvider
    });
  }
}
