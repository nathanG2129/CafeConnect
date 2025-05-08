import 'package:flutter/material.dart';
import '../../widgets/app_drawer.dart';
import '../../services/auth_service.dart';
import '../../models/userModel.dart';

class StaffDashboardPage extends StatefulWidget {
  static const String routeName = '/staff-dashboard';
  
  const StaffDashboardPage({super.key});

  @override
  State<StaffDashboardPage> createState() => _StaffDashboardPageState();
}

class _StaffDashboardPageState extends State<StaffDashboardPage> {
  final AuthService _authService = AuthService();
  UserModel? _currentUser;
  bool _isLoading = true;

  // Sample data - In a real app, these would come from API/database
  final int _totalProducts = 24;
  final int _pendingOrders = 7;
  final double _todaySales = 523.50;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final user = await _authService.getCurrentUserData();
      setState(() {
        _currentUser = user;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: UniqueKey(),
      backgroundColor: const Color(0xFFF5E6D3),
      appBar: AppBar(
        title: const Text("Staff Dashboard"),
        centerTitle: true,
        backgroundColor: Colors.brown[800],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadUserData,
            tooltip: 'Refresh',
          ),
        ],
      ),
      drawer: const AppDrawer(currentRoute: '/staff-dashboard'),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.brown))
          : _buildResponsiveLayout(),
    );
  }

  Widget _buildResponsiveLayout() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1100) {
          // Desktop layout
          return _buildDesktopLayout();
        } else if (constraints.maxWidth >= 650) {
          // Tablet layout
          return _buildTabletLayout();
        } else {
          // Mobile layout
          return _buildMobileLayout();
        }
      },
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Side panel with staff info
        Expanded(
          flex: 3,
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.brown.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStaffHeader(),
                  const SizedBox(height: 32),
                  _buildActivitySummary(),
                ],
              ),
            ),
          ),
        ),
        // Main content area
        Expanded(
          flex: 7,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildStatisticsSection(isHorizontal: true),
                const SizedBox(height: 24),
                _buildQuickAccessPanel(isDesktop: true),
                const SizedBox(height: 24),
                _buildNotificationsSection(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabletLayout() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStaffHeader(),
            const SizedBox(height: 24),
            _buildStatisticsSection(isHorizontal: true),
            const SizedBox(height: 24),
            _buildQuickAccessPanel(isDesktop: false),
            const SizedBox(height: 24),
            _buildActivitySummary(),
            const SizedBox(height: 24),
            _buildNotificationsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStaffHeader(),
            const SizedBox(height: 24),
            _buildStatisticsSection(isHorizontal: false),
            const SizedBox(height: 24),
            _buildQuickAccessPanel(isDesktop: false),
            const SizedBox(height: 24),
            _buildActivitySummary(),
            const SizedBox(height: 24),
            _buildNotificationsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildStaffHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.brown[800]!,
            Colors.brown[700]!,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.brown.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.amber[200],
            radius: 36,
            child: Icon(
              Icons.person,
              color: Colors.brown[800],
              size: 40,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome, ${_currentUser?.name ?? 'Staff Member'}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.amber[700],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "Staff Portal",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Last login: Today, 9:30 AM",
                      style: TextStyle(
                        color: Colors.brown[100],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivitySummary() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Recent Activity",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.brown[800],
              ),
            ),
            const SizedBox(height: 16),
            _buildActivityItem(
              icon: Icons.update,
              title: "Menu Updated",
              description: "You updated the Espresso price",
              time: "Today, 10:45 AM",
              iconColor: Colors.blue[700]!,
            ),
            _buildActivityItem(
              icon: Icons.check_circle,
              title: "Order Completed",
              description: "Order #1234 was completed",
              time: "Today, 9:30 AM",
              iconColor: Colors.green[600]!,
            ),
            _buildActivityItem(
              icon: Icons.local_offer,
              title: "New Special Added",
              description: "Weekend Special discount created",
              time: "Yesterday, 5:20 PM",
              iconColor: Colors.orange[600]!,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required String title,
    required String description,
    required String time,
    required Color iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessPanel({required bool isDesktop}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Quick Access",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.brown[800],
              ),
            ),
            const SizedBox(height: 20),
            LayoutBuilder(
              builder: (context, constraints) {
                // Adapt to available width
                final crossAxisCount = isDesktop ? 3 : constraints.maxWidth > 450 ? 3 : 2;
                final aspectRatio = isDesktop ? 1.5 : 1.2;
                
                return GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: aspectRatio,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildQuickAccessItem(
                      icon: Icons.coffee,
                      title: "Manage Products",
                      color: Colors.amber[700]!,
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/manage-products');
                      },
                    ),
                    _buildQuickAccessItem(
                      icon: Icons.receipt_long,
                      title: "Manage Orders",
                      color: Colors.green[600]!,
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/manage-orders');
                      },
                    ),
                    _buildQuickAccessItem(
                      icon: Icons.local_offer,
                      title: "Special Offers",
                      color: Colors.orange[600]!,
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/manage-specials');
                      },
                    ),
                  ],
                );
              }
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAccessItem({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: 36,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: color.withOpacity(0.9),
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsSection({required bool isHorizontal}) {
    if (isHorizontal) {
      return Row(
        children: [
          Expanded(
            child: _buildStatCard(
              title: "Products",
              value: "$_totalProducts",
              icon: Icons.coffee,
              color: Colors.amber[700]!,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              title: "Pending Orders",
              value: "$_pendingOrders",
              icon: Icons.receipt_long,
              color: Colors.green[600]!,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              title: "Today's Sales",
              value: "₱${_todaySales.toStringAsFixed(2)}",
              icon: Icons.attach_money,
              color: Colors.purple[600]!,
            ),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          _buildStatCard(
            title: "Products",
            value: "$_totalProducts",
            icon: Icons.coffee,
            color: Colors.amber[700]!,
          ),
          const SizedBox(height: 16),
          _buildStatCard(
            title: "Pending Orders",
            value: "$_pendingOrders",
            icon: Icons.receipt_long,
            color: Colors.green[600]!,
          ),
          const SizedBox(height: 16),
          _buildStatCard(
            title: "Today's Sales",
            value: "₱${_todaySales.toStringAsFixed(2)}",
            icon: Icons.attach_money,
            color: Colors.purple[600]!,
          ),
        ],
      );
    }
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown[800],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Notifications",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown[800],
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "View All",
                    style: TextStyle(
                      color: Colors.brown[600],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildNotificationItem(
              title: "New Order #1237",
              message: "John D. placed a new order with 3 items",
              time: "Just now",
              isNew: true,
            ),
            _buildNotificationItem(
              title: "Low Inventory Alert",
              message: "Arabica Coffee is running low on stock",
              time: "1 hour ago",
              isNew: true,
            ),
            _buildNotificationItem(
              title: "Staff Meeting",
              message: "Weekly staff meeting at 5PM today",
              time: "3 hours ago",
              isNew: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem({
    required String title,
    required String message,
    required String time,
    required bool isNew,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 12,
            height: 12,
            margin: const EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isNew ? Colors.amber[700] : Colors.transparent,
              border: Border.all(
                color: isNew ? Colors.amber[700]! : Colors.grey.withOpacity(0.5),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: isNew ? FontWeight.bold : FontWeight.normal,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 