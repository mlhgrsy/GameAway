import 'dart:io';
import 'package:path/path.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
      User user = result.user!;
      DBService.addUser(user.uid, false, name + " " + surname);
      await user.updateDisplayName(name + " " + surname);
      await user.updatePhotoURL(
          "https://ih1.redbubble.net/image.1046392278.3346/pp,840x830-pad,1000x1000,f8f8f8.jpg");
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
      await DBService.updateName(_auth.currentUser!.uid, newName);
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
      await DBService.updateMail(_auth.currentUser!.uid, newMail);
      return true;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future updatePP(File file) async {
    try {
      var ref = FirebaseStorage.instance.ref();
      String filepath =
          "/profileImages/${_auth.currentUser!.uid}${extension(file.path)}";
      await ref.child(filepath).putFile(file);
      String ppURL = await ref.child(filepath).getDownloadURL();
      await _auth.currentUser!.updatePhotoURL(ppURL);
      await DBService.updatePP(_auth.currentUser!.uid, ppURL);
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
      DBService.addUser(_auth.currentUser!.uid, true, googleUser.displayName!);
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
