import 'package:flutter/material.dart';
import 'pages/user/home_page.dart';
import 'pages/auth/login_page.dart';
import 'pages/auth/registration_page.dart';
import 'pages/user/profile_page.dart';
import 'pages/user/order_menu.dart';
import 'pages/user/order_history.dart';
import 'pages/user/coffee_guide.dart';
import 'pages/user/about_page.dart';
import 'pages/staff/staff_dashboard.dart';
import 'pages/staff/manage_products_page.dart';
import 'package:get_storage/get_storage.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Activity 1",
      theme: ThemeData(
        primarySwatch: Colors.brown,
        scaffoldBackgroundColor: const Color(0xFFF5E6D3),
      ),
      home: const HomePage(),
      routes: {
        '/home': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegistrationPage(),
        '/profile': (context) => const ProfilePage(),
        '/menu': (context) => const OrderMenuPage(),
        '/order-history': (context) => const OrderHistoryPage(),
        '/guide': (context) => const CoffeeGuidePage(),
        '/about': (context) => const AboutPage(),
        '/staff-dashboard': (context) => const StaffDashboardPage(),
        '/manage-products': (context) => const ManageProductsPage(),
      },
    );
  }
}