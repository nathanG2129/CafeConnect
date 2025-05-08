import 'package:flutter/material.dart';
import 'package:flutter_activity1/pages/staff/manage_products_page.dart';
import 'package:flutter_activity1/pages/staff/staff_dashboard.dart';
import 'package:flutter_activity1/pages/staff/manage_orders_page.dart';
import 'package:flutter_activity1/pages/admin/update_pricing_page.dart';
import 'package:flutter_activity1/pages/user/home_page.dart';
import 'package:flutter_activity1/pages/auth/login_page.dart';
import 'package:flutter_activity1/pages/auth/registration_page.dart';
import 'package:flutter_activity1/pages/user/profile_page.dart';
import 'package:flutter_activity1/pages/user/order_menu.dart';
import 'package:flutter_activity1/pages/user/order_history.dart';
import 'package:flutter_activity1/pages/user/coffee_guide.dart';
import 'package:flutter_activity1/pages/user/about_page.dart';

// Define all app routes here
Map<String, WidgetBuilder> appRoutes = {
  // User Routes
  '/home': (context) => const HomePage(),
  '/login': (context) => const LoginPage(),
  '/register': (context) => const RegistrationPage(),
  '/profile': (context) => const ProfilePage(),
  '/menu': (context) => const OrderMenuPage(),
  '/order-history': (context) => const OrderHistoryPage(),
  '/guide': (context) => const CoffeeGuidePage(),
  '/about': (context) => const AboutPage(),
  
  // Staff Routes
  '/staff-dashboard': (context) => const StaffDashboardPage(),
  '/manage-products': (context) => const ManageProductsPage(),
  '/manage-orders': (context) => const ManageOrdersPage(),
  '/update-pricing': (context) => const UpdatePricingPage(),
}; 