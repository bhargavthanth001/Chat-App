import 'package:chat_app/DB%20Manager/database_halper.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignIn {
  static Future<UserCredential> siginWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    DBHelper.createUser();

    return userCredential;
  }

  static Future<void> signOutGoogle() async {
    await GoogleSignIn().signOut();
    debugPrint("User Sign Out");
  }
}
