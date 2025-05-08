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
      // print(e.toString());
      return null;
    }
  }

  // Sign in user with email and password
  Future<UserModel?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      // Sign in with email and password
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Get user id
      String uid = result.user!.uid;
      
      // Get user document from Firestore
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        // Create UserModel from Firestore data
        UserModel userModel = UserModel(
          id: uid,
          name: data['name'],
          email: data['email'],
          phoneNumber: data['phoneNumber'],
          favoriteCoffee: data['favoriteCoffee'],
          preferredVisitTime: data['preferredVisitTime'],
          specialPreferences: data['specialPreferences'],
        );
        return userModel;
      }
      return null;
    } catch (e) {
      // print(e.toString());
      return null;
    }
  }

  // Update user in Firestore
  Future<bool> updateUserData(UserModel userModel) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        await _firestore.collection('users').doc(currentUser.uid).update({
          'name': userModel.name,
          'email': userModel.email,
          'phoneNumber': userModel.phoneNumber,
          'favoriteCoffee': userModel.favoriteCoffee,
          'preferredVisitTime': userModel.preferredVisitTime,
          'specialPreferences': userModel.specialPreferences,
          'updatedAt': FieldValue.serverTimestamp(),
        });
        return true;
      }
      return false;
    } catch (e) {
      // print(e.toString());
      return false;
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

  // Check if user is logged in
  bool isUserLoggedIn() {
    return _auth.currentUser != null;
  }

  // Get current user data from Firestore
  Future<UserModel?> getCurrentUserData() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        DocumentSnapshot doc = await _firestore.collection('users').doc(currentUser.uid).get();
        if (doc.exists) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          return UserModel(
            id: currentUser.uid,
            name: data['name'],
            email: data['email'],
            phoneNumber: data['phoneNumber'],
            favoriteCoffee: data['favoriteCoffee'],
            preferredVisitTime: data['preferredVisitTime'],
            specialPreferences: data['specialPreferences'],
          );
        }
      }
      return null;
    } catch (e) {
      // print(e.toString());
      return null;
    }
  }
}
