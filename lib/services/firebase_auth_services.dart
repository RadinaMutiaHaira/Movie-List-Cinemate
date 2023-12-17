import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseAuthService {
  static final FirebaseAuthService _instance = FirebaseAuthService._internal();
  factory FirebaseAuthService() => _instance;

  FirebaseAuthService._internal();

  FirebaseAuth _authService = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPasswordAndData(
    String email,
    String password,
    String name,
    String phoneNumber,
    String country,
    BuildContext context,
  ) async {
    try {
      UserCredential credential = await _authService
          .createUserWithEmailAndPassword(email: email, password: password);
// Simpan data tambahan ke Firestore
      await saveUserDataToFirestore(
        credential.user!.uid,
        email,
        name,
        phoneNumber,
        country,
      );

      return credential.user;
    } catch (e) {
      final String errorMessage = e.toString();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
      ));
      return null;
    }
  }

  Future<User?> loginWithEmailandPassword(
      String email, password, BuildContext context) async {
    try {
      UserCredential credential = await _authService.signInWithEmailAndPassword(
          email: email, password: password);
          
      return credential.user;
    } catch (e) {
      final String errorMessage = e.toString();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
      ));
      return null;
    }
  }

  Future<void> saveUserDataToFirestore(
    String uid,
    String email,
    String name,
    String phoneNumber,
    String country,
  ) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'email': email,
      'name': name,
      'phoneNumber': phoneNumber,
      'country': country,
    });
  }

  Future<Map<String, dynamic>?> getUserDataFromFirestore(String uid) async {
  try {
    DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return userDoc.data();
  } catch (e) {
    // Handle error
    return null;
  }
}

}
