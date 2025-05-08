import 'package:flutter/material.dart';
import 'package:flutter_activity1/pages/staff/manage_products_page.dart';
import 'package:flutter_activity1/pages/staff/staff_dashboard.dart';

// Define all app routes here
Map<String, WidgetBuilder> appRoutes = {
  // Staff Routes
  '/staff-dashboard': (context) => const StaffDashboardPage(),
  '/manage-products': (context) => const ManageProductsPage(),
}; 