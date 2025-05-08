import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/orderModel.dart';
import '../../models/orderItemModel.dart';
import '../../services/order_service.dart';
import '../../widgets/app_drawer.dart';


class ManageOrdersPage extends StatefulWidget {
  static const String routeName = '/manage-orders';
  
  const ManageOrdersPage({super.key});

  @override
  State<ManageOrdersPage> createState() => _ManageOrdersPageState();
}

class _ManageOrdersPageState extends State<ManageOrdersPage> with SingleTickerProviderStateMixin {
  final OrderService _orderService = OrderService();
  late TabController _tabController;
  bool _isLoading = true;
  bool _isRefreshing = false;
  List<OrderModel> _allOrders = [];
  
  // Filter orders by status
  List<OrderModel> get _pendingOrders => _allOrders.where((order) => order.status == 'Pending').toList();
  List<OrderModel> get _preparingOrders => _allOrders.where((order) => order.status == 'Preparing').toList();
  List<OrderModel> get _readyOrders => _allOrders.where((order) => order.status == 'Ready').toList();
  List<OrderModel> get _completedOrders => _allOrders.where((order) => order.status == 'Completed').toList();
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadOrders();
    
    // Set up a periodic refresh instead of refreshing on tab change
    _setupPeriodicRefresh();
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  void _setupPeriodicRefresh() {
    // Refresh data every 30 seconds in the background
    Future.delayed(const Duration(seconds: 30), () {
      if (mounted) {
        _refreshOrdersInBackground();
        _setupPeriodicRefresh(); // Schedule the next refresh
      }
    });
  }
  
  Future<void> _refreshOrdersInBackground() async {
    if (!mounted) return;
    
    // Don't show loading indicator for background refreshes
    setState(() {
      _isRefreshing = true;
    });
    
    try {
      final orders = await _orderService.getAllOrders();
      
      if (mounted) {
        setState(() {
          _allOrders = orders;
          _isRefreshing = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isRefreshing = false;
        });
      }
      // Silent error handling for background refreshes
    }
  }
  
  Future<void> _loadOrders() async {
    if (_isRefreshing) return; // Don't load if already refreshing in background
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final orders = await _orderService.getAllOrders();
      
      setState(() {
        _allOrders = orders;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading orders: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E6D3),
      appBar: AppBar(
        title: const Text("Manage Orders"),
        centerTitle: true,
        backgroundColor: Colors.brown[800],
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.amber[200],
          indicatorWeight: 3,
          tabs: [
            Tab(
              icon: const Icon(Icons.hourglass_empty),
              text: 'Pending (${_pendingOrders.length})',
            ),
            Tab(
              icon: const Icon(Icons.coffee),
              text: 'Preparing (${_preparingOrders.length})',
            ),
            Tab(
              icon: const Icon(Icons.done_all),
              text: 'Ready (${_readyOrders.length})',
            ),
            Tab(
              icon: const Icon(Icons.check_circle),
              text: 'Completed (${_completedOrders.length})',
            ),
          ],
        ),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _loadOrders,
                tooltip: 'Refresh Orders',
              ),
              if (_isRefreshing)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.amber,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      drawer: const AppDrawer(currentRoute: '/manage-orders'),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.brown))
          : TabBarView(
              controller: _tabController,
              children: [
                _buildOrderList(_pendingOrders, 'No pending orders'),
                _buildOrderList(_preparingOrders, 'No orders in preparation'),
                _buildOrderList(_readyOrders, 'No orders ready for pickup'),
                _buildOrderList(_completedOrders, 'No completed orders'),
              ],
            ),
    );
  }
  
  Widget _buildOrderList(List<OrderModel> orders, String emptyMessage) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.coffee_outlined,
              size: 64,
              color: Colors.brown[300],
            ),
            const SizedBox(height: 16),
            Text(
              emptyMessage,
              style: TextStyle(
                color: Colors.brown[600],
                fontSize: 18,
              ),
            ),
          ],
        ),
      );
    }
    
    return RefreshIndicator(
      onRefresh: _loadOrders,
      color: Colors.brown,
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return _buildOrderCard(order);
        },
      ),
    );
  }
  
  Widget _buildOrderCard(OrderModel order) {
    // Define next status based on current status
    String? nextStatus;
    IconData nextStatusIcon = Icons.arrow_forward;
    String nextStatusText = 'Move to Next Step';
    
    switch (order.status) {
      case 'Pending':
        nextStatus = 'Preparing';
        nextStatusIcon = Icons.coffee;
        nextStatusText = 'Start Preparing';
        break;
      case 'Preparing':
        nextStatus = 'Ready';
        nextStatusIcon = Icons.done_all;
        nextStatusText = 'Mark as Ready';
        break;
      case 'Ready':
        nextStatus = 'Completed';
        nextStatusIcon = Icons.check_circle;
        nextStatusText = 'Complete Order';
        break;
      case 'Completed':
        // No next status for completed orders
        nextStatus = null;
        break;
    }
    
    // Get a representative image for the order
    String mainImagePath = order.items.isNotEmpty 
        ? order.items.first.imagePath 
        : 'assets/coffees/default.jpg';
    
    // Get total number of items
    int totalItems = order.items.fold(0, (sum, item) => sum + item.quantity);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order header - Order ID, date, and status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      // Representative order image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          mainImagePath,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Order ID and date
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Order #${order.id.substring(order.id.length - 5)}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.brown,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Ordered: ${DateFormat('MMM dd, yyyy • h:mm a').format(order.orderDate)}',
                              style: TextStyle(
                                color: Colors.brown[400],
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$totalItems ${totalItems == 1 ? 'item' : 'items'} • ₱${order.totalAmount.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: Colors.brown[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Status indicator
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order.status),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getStatusIcon(order.status),
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        order.status,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Divider between header and items
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Divider(color: Colors.brown[200]),
            ),

            // List of order items
            ...order.items.map((item) => _buildOrderItemTile(item)).toList(),

            // Order summary
            if (order.items.length > 1) ... [
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Divider(color: Colors.brown[200]),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Subtotal: ₱${order.subtotal.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.brown[700],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Tax: ₱${order.tax.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.brown[700],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Total: ₱${order.totalAmount.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown[800],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],

            // Action button
            if (nextStatus != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _updateOrderStatus(order.id, nextStatus!),
                    icon: Icon(nextStatusIcon, size: 18),
                    label: Text(nextStatusText),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown[700],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  // Helper method to display each order item
  Widget _buildOrderItemTile(OrderItemModel item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Item image
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.asset(
              item.imagePath,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          
          // Item details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.coffeeName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  'Size: ${item.size}${item.addOn != null ? ' • ${item.addOn}' : ''}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.brown[600],
                  ),
                ),
              ],
            ),
          ),
          
          // Item quantity and price
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${item.quantity}x',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.brown[700],
                ),
              ),
              Text(
                '₱${item.totalPrice.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown[700],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Preparing':
        return Colors.blue;
      case 'Ready':
        return Colors.green;
      case 'Completed':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
  
  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'Pending':
        return Icons.hourglass_empty;
      case 'Preparing':
        return Icons.coffee;
      case 'Ready':
        return Icons.done_all;
      case 'Completed':
        return Icons.check_circle;
      default:
        return Icons.help_outline;
    }
  }
  
  Future<void> _updateOrderStatus(String orderId, String newStatus) async {
    try {
      final success = await _orderService.updateOrderStatus(orderId, newStatus);
      
      if (!mounted) return;
      
      if (success) {
        // Refresh orders
        await _loadOrders();
        
        if (!mounted) return;
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Order status updated to $newStatus'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        if (!mounted) return;
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update order status'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
} 