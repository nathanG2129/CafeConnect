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
          : _buildDashboard(),
    );
  }

  Widget _buildDashboard() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStaffHeader(),
            const SizedBox(height: 24),
            _buildQuickAccessPanel(),
            const SizedBox(height: 24),
            _buildStatisticsSection(),
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
        color: Colors.brown[800],
        borderRadius: BorderRadius.circular(12),
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
            radius: 30,
            child: Icon(
              Icons.person,
              color: Colors.brown[800],
              size: 36,
            ),
          ),
          const SizedBox(width: 16),
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
                const SizedBox(height: 4),
                Text(
                  "Staff Portal",
                  style: TextStyle(
                    color: Colors.amber[200],
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessPanel() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                // Adapt to available width
                final crossAxisCount = constraints.maxWidth > 450 ? 3 : 2;
                return GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: 1.2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  children: [
                    _buildQuickAccessItem(
                      icon: Icons.coffee,
                      title: "Products",
                      color: Colors.amber[700]!,
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/manage-products');
                      },
                    ),
                    _buildQuickAccessItem(
                      icon: Icons.receipt_long,
                      title: "Orders",
                      color: Colors.green[600]!,
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/manage-orders');
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
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: 28,
            ),
            const SizedBox(height: 6),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "System Status",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.brown[800],
              ),
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                // Use single column layout for small screens
                if (constraints.maxWidth < 400) {
                  return Column(
                    children: [
                      _buildStatCard(
                        title: "Products",
                        value: "$_totalProducts",
                        icon: Icons.coffee,
                        color: Colors.amber[700]!,
                      ),
                      const SizedBox(height: 12),
                      _buildStatCard(
                        title: "Pending Orders",
                        value: "$_pendingOrders",
                        icon: Icons.hourglass_bottom,
                        color: Colors.orange[600]!,
                      ),
                      const SizedBox(height: 12),
                      _buildStatCard(
                        title: "Today's Sales",
                        value: "₱${_todaySales.toStringAsFixed(2)}",
                        icon: Icons.attach_money,
                        color: Colors.green[600]!,
                      ),
                      const SizedBox(height: 12),
                      _buildStatCard(
                        title: "System Status",
                        value: "Online",
                        icon: Icons.cloud_done,
                        color: Colors.blue[600]!,
                      ),
                    ],
                  );
                }
                
                // Use two-column layout for larger screens
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            title: "Products",
                            value: "$_totalProducts",
                            icon: Icons.coffee,
                            color: Colors.amber[700]!,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            title: "Pending Orders",
                            value: "$_pendingOrders",
                            icon: Icons.hourglass_bottom,
                            color: Colors.orange[600]!,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            title: "Today's Sales",
                            value: "₱${_todaySales.toStringAsFixed(2)}",
                            icon: Icons.attach_money,
                            color: Colors.green[600]!,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            title: "System Status",
                            value: "Online",
                            icon: Icons.cloud_done,
                            color: Colors.blue[600]!,
                          ),
                        ),
                      ],
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

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                icon,
                color: color,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.brown[800],
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
} 