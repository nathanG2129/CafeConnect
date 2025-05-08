import 'package:flutter/material.dart';
import '../../widgets/app_drawer.dart';
import '../../services/auth_service.dart';
import '../../models/userModel.dart';
import '../../services/product_service.dart';
import '../../services/order_service.dart';
import '../../models/orderModel.dart';

class StaffDashboardPage extends StatefulWidget {
  static const String routeName = '/staff-dashboard';
  
  const StaffDashboardPage({super.key});

  @override
  State<StaffDashboardPage> createState() => _StaffDashboardPageState();
}

class _StaffDashboardPageState extends State<StaffDashboardPage> {
  final AuthService _authService = AuthService();
  final ProductService _productService = ProductService();
  final OrderService _orderService = OrderService();
  
  UserModel? _currentUser;
  bool _isLoading = true;

  // Data to be fetched
  int _totalProducts = 0;
  int _pendingOrders = 0;
  double _todaySales = 0.0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Load multiple data sources in parallel
      final userFuture = _authService.getCurrentUserData();
      final productsFuture = _productService.getAllProducts();
      final ordersFuture = _orderService.getAllOrders();
      
      // Wait for all futures to complete
      final results = await Future.wait([
        userFuture,
        productsFuture,
        ordersFuture,
      ]);
      
      // Process results
      final user = results[0] as UserModel?;
      final products = results[1] as List;
      final orders = results[2] as List<OrderModel>;
      
      // Calculate statistics
      final pendingOrders = orders.where((order) => order.status == 'Pending').length;
      
      // Calculate today's sales from completed orders
      final now = DateTime.now();
      final todayStart = DateTime(now.year, now.month, now.day);
      final todaySales = orders
        .where((order) => order.status == 'Completed' && order.orderDate.isAfter(todayStart))
        .fold(0.0, (sum, order) => sum + order.totalAmount);
      
      if (mounted) {
        setState(() {
          _currentUser = user;
          _totalProducts = products.length;
          _pendingOrders = pendingOrders;
          _todaySales = todaySales;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading dashboard data: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
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
            onPressed: _loadData,
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
              ],
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
} 