import 'package:campus_assistant/firebase_code/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:campus_assistant/user_status.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthFunct {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // register
  Future registerUserWithEmailandPassword(
      String fullName, String email, String password) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;
      if (user != null) {
        await DatabaseFunct(uid: user.uid).updateUserData(fullName, email);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      //print(e);
      return e.message;
    }
  }

  // login
  Future loginUserWithEmailandPassword(String email, String password) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;
      if (user != null) {
        return true;
      }
    } on FirebaseAuthException catch (e) {
      //print(e);
      return e.message;
    }
  }

  // delete user
  Future<void> deleteUser(String currentUserId) async {
    // get current user's data.
    final userCollection = FirebaseFirestore.instance.collection("users");
    final userDoc = await userCollection.doc(currentUserId).get();
    final userData = userDoc.data();

    // if the user you are deleting has the current user's UID...
    if (userData?['uid'] == currentUserId) {
      // ...delete current user from user collection
      await userCollection.doc(currentUserId).delete();
      // ... and from authenticate as well
      await firebaseAuth.currentUser!.delete();

      // TODO: popup in app that says "account successfully deleted"
      debugPrint("deleted...");
    } else {
      // shouldn't be null.
      // you can only delete your own currently signed in account.

      debugPrint("uid =/= uid???");
      throw Exception('You can\'t delete another user!');
    }
  }

  // delete user
  Future<bool> deleteUserAsAdmin(String givenUserId) async {
    // get current user's data.
    final userCollection = FirebaseFirestore.instance.collection("users");

    bool isAdmin = await UserStatus().getUserAdminStatus() as bool;

    // if the user you are deleting has the current user's UID...
    if (isAdmin) {
      // ...delete current user from user collection
      await userCollection.doc(givenUserId).delete();
      //UserRecord userRecord = FirebaseAuth.getInstance().getUser(uid);
      // ... and from authenticate as well
      return true;
      debugPrint("deleted...");
    } else {
      // shouldn't be null.
      // you can only delete your own currently signed in account.

      debugPrint("not admine");
      return false;
    }
  }

  // log out
  Future signout() async {
    try {
      await UserStatus.saveUserLoggedIn(false);
      await UserStatus.saveUserEmail("");
      await UserStatus.saveUserName("");
      await UserStatus.saveUserStatus(false);
      await firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }
}
