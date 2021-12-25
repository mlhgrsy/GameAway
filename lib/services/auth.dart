import 'package:firebase_auth/firebase_auth.dart';
import 'package:gameaway/services/db.dart';

import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _userFromFirebase(User? user) {
    return user ?? null;
  }

  Stream<User?> get user {
    return _auth.authStateChanges().map(_userFromFirebase);
  }

  Future signupWithMailAndPass(
      String mail, String pass, String name, String surname) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: mail, password: pass);
      User user = result.user!;
      DBService.addUser(name + " " + surname, mail);
      return _userFromFirebase(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signInWithMailAndPass(String mail, String pass) async {
    try {
      UserCredential result =
          await _auth.signInWithEmailAndPassword(email: mail, password: pass);
      User user = result.user!;
      return _userFromFirebase(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      //User user=googleUser.email as User;

      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      DBService.addUser(
          _auth.currentUser!.displayName!, _auth.currentUser!.email!);
      return;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
