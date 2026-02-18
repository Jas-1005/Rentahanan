import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Sign Up Logic
  Future<UserCredential?> signUp({
    required String email,
    required String password,
    required String fullName,
    required String contact,
  }) async {
    try {
      // 1. Create User in Firebase Auth
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 2. Create User Profile in Firestore
      UserModel newUser = UserModel(
        uid: cred.user!.uid,
        email: email,
        fullName: fullName,
        contactNumber: contact
      );

      await _db.collection('users').doc(cred.user!.uid).set(newUser.toMap());
      
      return cred;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async => await _auth.signOut();
}