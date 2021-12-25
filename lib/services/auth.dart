import 'package:firebase_auth/firebase_auth.dart';
import 'package:gameaway/services/db.dart';

import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _userFromFirebase(User? user) {
    return user ?? null;
  }

  Stream<User?> get user {
    print("user getter rerun");
    return _auth.userChanges().map(_userFromFirebase);
  }

  Future signupWithMailAndPass(
      String mail, String pass, String name, String surname) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: mail, password: pass);
      //Şifre değiştirmeyi unutma
      User user = result.user!;
      DBService.addUser(user.uid, false);
      await user.updateDisplayName(name + " " + surname);
      await user.updatePhotoURL(
          "https://i.ytimg.com/vi/tZp8sY06Qoc/maxresdefault.jpg");
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

  Future updatePassword(String oldPass, String newPass) async {
    AuthCredential cred = EmailAuthProvider.credential(
        email: _auth.currentUser!.email!, password: oldPass);
    try {
      await _auth.currentUser!.reauthenticateWithCredential(cred);
      await _auth.currentUser!.updatePassword(newPass);
      return true;
    } catch (e) {
      return null;
    }
  }

  Future updateName(String newName) async {
    try {
      await _auth.currentUser!.updateDisplayName(newName);
      return true;
    } catch (e) {
      return null;
    }
  }

  Future updateMail(String newMail, String pass) async {
    AuthCredential cred = EmailAuthProvider.credential(
        email: _auth.currentUser!.email!, password: pass);
    try {
      await _auth.currentUser!.reauthenticateWithCredential(cred);
      await _auth.currentUser!.updateEmail(newMail);
      return true;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      DBService.addUser(_auth.currentUser!.uid, true);
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
