import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_activity1/firebase_options.dart';
import 'package:flutter_activity1/models/userModel.dart';
import 'package:flutter_activity1/services/auth_service.dart';
import 'dart:io';

/*
 * This script creates 2 staff accounts for the application.
 * 
 * Usage:
 * 1. Run the script using: flutter pub run scripts/create_staff_accounts.dart
 * 2. The script will create these staff accounts:
 *    - staff1@example.com / password: staff123
 *    - staff2@example.com / password: staff123
 */

void main() async {
  // Initialize Flutter bindings
  // This is required for Firebase initialization when running outside the app
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Create the AuthService instance
  final AuthService authService = AuthService();
  
  // Define staff accounts to create
  final List<Map<String, dynamic>> staffAccounts = [
    {
      'email': 'staff1@example.com',
      'password': 'staff123',
      'name': 'Staff One',
      'phoneNumber': '+639171234567',
      'role': 'staff',
    },
    {
      'email': 'staff2@example.com',
      'password': 'staff123',
      'name': 'Staff Two',
      'phoneNumber': '+639181234567',
      'role': 'staff',
    },
  ];
  
  // Create each staff account
  for (var staffData in staffAccounts) {
    try {
      
      // Create user model
      final UserModel staffUser = UserModel(
        name: staffData['name'],
        email: staffData['email'],
        phoneNumber: staffData['phoneNumber'],
        role: staffData['role'],
      );
      
      // Register the user with Firebase
      final result = await authService.registerUser(
        email: staffData['email'],
        password: staffData['password'],
        userModel: staffUser,
      );
      
      if (result != null) {
      } else {
      }
    } catch (e) {

    }
  }
  
  
  // Exit the script
  exit(0);
} 