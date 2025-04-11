import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_activity1/models/userModel.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create user in Firebase Auth and Firestore
  Future<UserModel?> registerUser({
    required String email,
    required String password,
    required UserModel userModel,
  }) async {
    try {
      // Create user in Firebase Auth
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Get user id from Auth
      String uid = result.user!.uid;
      
      // Create user document in Firestore
      await _firestore.collection('users').doc(uid).set({
        'name': userModel.name,
        'email': userModel.email,
        'phoneNumber': userModel.phoneNumber,
        'favoriteCoffee': userModel.favoriteCoffee,
        'preferredVisitTime': userModel.preferredVisitTime,
        'specialPreferences': userModel.specialPreferences,
        'createdAt': FieldValue.serverTimestamp(),
      });
      
      return userModel;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Sign out user
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
