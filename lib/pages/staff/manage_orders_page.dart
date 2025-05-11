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
          : _buildResponsiveLayout(),
    );
  }
  
  Widget _buildResponsiveLayout() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // On desktop screens, we can optimize layout
        if (constraints.maxWidth >= 1100) {
          return _buildDesktopLayout();
        } else {
          // Tablet and mobile use the same layout with TabBarView
          return TabBarView(
            controller: _tabController,
            children: [
              _buildOrderList(_pendingOrders, 'No pending orders'),
              _buildOrderList(_preparingOrders, 'No orders in preparation'),
              _buildOrderList(_readyOrders, 'No orders ready for pickup'),
              _buildOrderList(_completedOrders, 'No completed orders'),
            ],
          );
        }
      },
    );
  }
  
  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Side navigation for desktop
        Container(
          width: 280,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.brown.withOpacity(0.1),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  "Order Status",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown[800],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildTabItem("Pending", _pendingOrders.length, Icons.hourglass_empty, 0),
              _buildTabItem("Preparing", _preparingOrders.length, Icons.coffee, 1),
              _buildTabItem("Ready", _readyOrders.length, Icons.done_all, 2),
              _buildTabItem("Completed", _completedOrders.length, Icons.check_circle, 3),
              const Divider(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildOrderStatusSummary(),
              ),
            ],
          ),
        ),
        
        // Main content area
        Expanded(
          child: IndexedStack(
            index: _tabController.index,
            children: [
              _buildOrderList(_pendingOrders, 'No pending orders'),
              _buildOrderList(_preparingOrders, 'No orders in preparation'),
              _buildOrderList(_readyOrders, 'No orders ready for pickup'),
              _buildOrderList(_completedOrders, 'No completed orders'),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildTabItem(String title, int count, IconData icon, int index) {
    final isSelected = _tabController.index == index;
    
    return InkWell(
      onTap: () {
        _tabController.animateTo(index);
        setState(() {});
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.brown.withOpacity(0.1) : Colors.transparent,
          border: Border(
            left: BorderSide(
              color: isSelected ? Colors.brown : Colors.transparent,
              width: 4,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.brown[700] : Colors.brown[400],
              size: 22,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.brown[800] : Colors.brown[600],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isSelected ? Colors.brown[100] : Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "$count",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.brown[800] : Colors.grey[700],
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildOrderStatusSummary() {
    final totalOrders = _allOrders.length;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Orders Summary",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.brown[800],
          ),
        ),
        const SizedBox(height: 16),
        _buildOrderStat("Total Orders", totalOrders),
        const SizedBox(height: 12),
        _buildOrderStat("Pending", _pendingOrders.length, Colors.orange),
        const SizedBox(height: 8),
        _buildOrderStat("Preparing", _preparingOrders.length, Colors.blue),
        const SizedBox(height: 8),
        _buildOrderStat("Ready", _readyOrders.length, Colors.green),
        const SizedBox(height: 8),
        _buildOrderStat("Completed", _completedOrders.length, Colors.grey),
      ],
    );
  }
  
  Widget _buildOrderStat(String label, int count, [Color? color]) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.brown[700],
            fontSize: 14,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: color != null ? color.withOpacity(0.1) : Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            "$count",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color ?? Colors.grey[700],
              fontSize: 14,
            ),
          ),
        ),
      ],
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

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWideLayout = constraints.maxWidth > 600;
        
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order header with status indicator
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: _getStatusColor(order.status).withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _getStatusColor(order.status).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getStatusIcon(order.status),
                        color: _getStatusColor(order.status),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order #${order.id.substring(order.id.length - 5)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Placed: ${DateFormat('MMM d, h:mm a').format(order.orderDate)}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getStatusColor(order.status).withOpacity(0.1),
                        border: Border.all(
                          color: _getStatusColor(order.status).withOpacity(0.5),
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        order.status,
                        style: TextStyle(
                          color: _getStatusColor(order.status),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Order details
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Customer info and total
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Customer',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Customer #${order.userId.substring(0, 5)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Total',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '₱${order.totalAmount.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.brown[800],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 8),
                    
                    // Order items
                    Text(
                      'Order Items',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.brown[800],
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    isWideLayout 
                        ? _buildWideOrderItems(order.items)
                        : _buildCompactOrderItems(order.items),
                    
                    const SizedBox(height: 16),
                    
                    // Action buttons
                    if (nextStatus != null)
                      Row(
                        mainAxisAlignment: isWideLayout
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () => _updateOrderStatus(order, nextStatus!),
                            icon: Icon(nextStatusIcon, size: 18),
                            label: Text(nextStatusText),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _getStatusColor(nextStatus),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                            ),
                          ),
                          if (order.status == 'Pending')
                            Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: OutlinedButton.icon(
                                onPressed: () => _updateOrderStatus(order, 'Cancelled'),
                                icon: const Icon(Icons.cancel_outlined, size: 18),
                                label: const Text('Cancel Order'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.red[700],
                                  side: BorderSide(color: Colors.red[200]!),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                ),
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
    );
  }
  
  Widget _buildWideOrderItems(List<OrderItemModel> items) {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(3),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(1),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(
          decoration: BoxDecoration(
            color: Colors.brown[50],
            borderRadius: BorderRadius.circular(8),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: Text(
                'Item',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.brown[700],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: Text(
                'Size',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.brown[700],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: Text(
                'Qty',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.brown[700],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: Text(
                'Price',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.brown[700],
                ),
              ),
            ),
          ],
        ),
        ...items.map((item) => TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: Text(
                item.coffeeName,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: Text(
                item.size ?? 'Regular',
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: Text(
                '${item.quantity}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: Text(
                '₱${item.totalPrice.toStringAsFixed(2)}',
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ],
        )).toList(),
      ],
    );
  }
  
  Widget _buildCompactOrderItems(List<OrderItemModel> items) {
    return Column(
      children: items.map((item) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.brown[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${item.quantity}x',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.brown[800],
                ),
              ),
            ),
            const SizedBox(width: 12),
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
                    'Size: ${item.size}',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '₱${item.totalPrice.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.brown[700],
              ),
            ),
          ],
        ),
      )).toList(),
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
        return Colors.grey;
      case 'Cancelled':
        return Colors.red;
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
      case 'Cancelled':
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }
  
  Future<void> _updateOrderStatus(OrderModel order, String newStatus) async {
    try {
      final success = await _orderService.updateOrderStatus(order.id, newStatus);
      
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