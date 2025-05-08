import 'package:flutter/material.dart';
import 'package:flutter_activity1/models/orderModel.dart';
import 'package:flutter_activity1/services/order_service.dart';
import 'package:flutter_activity1/models/cartModel.dart';
import 'package:intl/intl.dart';
import '../../widgets/app_drawer.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  final OrderService _orderService = OrderService();
  List<OrderModel> _orders = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final orders = await _orderService.getUserOrders();
      if (!mounted) return;
      setState(() {
        _orders = orders;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading orders: ${e.toString()}'),
          backgroundColor: Colors.red[600],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E6D3),
      appBar: AppBar(
        title: const Text("Order History"),
        centerTitle: true,
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadOrders,
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: _isLoading
          ? _buildLoadingState()
          : _hasError
              ? _buildErrorState()
              : _orders.isEmpty
                  ? _buildEmptyState()
                  : _buildOrderList(),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.brown),
          SizedBox(height: 16),
          Text(
            'Loading your orders...',
            style: TextStyle(color: Colors.brown, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
          const SizedBox(height: 16),
          Text(
            'Failed to load orders',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.brown[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please check your connection and try again',
            style: TextStyle(color: Colors.brown[600]),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _loadOrders,
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.brown[700],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long, size: 64, color: Colors.brown[300]),
          const SizedBox(height: 16),
          Text(
            'No Order History',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.brown[700],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'You haven\'t placed any orders yet. Start by ordering your favorite coffee!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.brown[600],
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.coffee),
            label: const Text('Browse Menu'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.brown[700],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderList() {
    // Group orders by date
    final Map<String, List<OrderModel>> groupedOrders = {};
    
    for (var order in _orders) {
      final dateStr = DateFormat('MMMM d, yyyy').format(order.orderDate);
      if (!groupedOrders.containsKey(dateStr)) {
        groupedOrders[dateStr] = [];
      }
      groupedOrders[dateStr]!.add(order);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: groupedOrders.length,
      itemBuilder: (context, index) {
        final date = groupedOrders.keys.elementAt(index);
        final dateOrders = groupedOrders[date]!;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                date,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown[800],
                ),
              ),
            ),
            ...dateOrders.map((order) => _buildOrderCard(order)).toList(),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }

  Widget _buildOrderCard(OrderModel order) {
    final timeStr = DateFormat('h:mm a').format(order.orderDate);
    
    // Status color mapping to match manage_orders_page.dart
    Color getStatusColor(String status) {
      switch (status.toLowerCase()) {
        case 'pending':
          return Colors.orange;
        case 'preparing':
          return Colors.blue;
        case 'ready':
          return Colors.green;
        case 'completed':
          return Colors.purple;
        case 'cancelled':
          return Colors.red;
        default:
          return Colors.grey;
      }
    }
    
    // Get status icon to match manage_orders_page.dart
    IconData getStatusIcon(String status) {
      switch (status.toLowerCase()) {
        case 'pending':
          return Icons.hourglass_empty;
        case 'preparing':
          return Icons.coffee;
        case 'ready':
          return Icons.done_all;
        case 'completed':
          return Icons.check_circle;
        case 'cancelled':
          return Icons.cancel;
        default:
          return Icons.help_outline;
      }
    }
    
    // Check if order can be cancelled (only pending or preparing orders)
    bool canCancel = order.status.toLowerCase() == 'pending' || 
                    order.status.toLowerCase() == 'preparing';
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    order.imagePath,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.coffeeName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Size: ${order.size}',
                        style: TextStyle(fontSize: 14, color: Colors.brown[600]),
                      ),
                      if (order.addOn != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          'Add-on: ${order.addOn}',
                          style: TextStyle(fontSize: 14, color: Colors.brown[600]),
                        ),
                      ],
                    ],
                  ),
                ),
                Text(
                  timeStr,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.brown[500],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: getStatusColor(order.status),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    getStatusIcon(order.status),
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
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Quantity: ${order.quantity}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '\$${order.totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _reorderItem(order),
                    icon: const Icon(Icons.replay),
                    label: const Text('Reorder'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.brown[700],
                      side: BorderSide(color: Colors.brown[700]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                if (canCancel) ...[
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _showCancelConfirmation(order),
                      icon: const Icon(Icons.cancel_outlined),
                      label: const Text('Cancel'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red[700],
                        side: BorderSide(color: Colors.red[700]!),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _reorderItem(OrderModel order) {
    // Add item to cart before navigating
    final cartModel = CartModel();
    cartModel.loadFromStorage();
    cartModel.addItem(order);
    
    // Navigate to menu page
    Navigator.pop(context);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${order.coffeeName} added to cart'),
        backgroundColor: Colors.green[600],
      ),
    );
  }

  // Show cancel confirmation dialog
  Future<void> _showCancelConfirmation(OrderModel order) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancel Order'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to cancel your order for ${order.coffeeName}?'),
                const SizedBox(height: 8),
                Text(
                  'This action cannot be undone.',
                  style: TextStyle(
                    color: Colors.red[700],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'No, Keep Order',
                style: TextStyle(color: Colors.brown[700]),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Yes, Cancel Order',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _cancelOrder(order);
              },
            ),
          ],
        );
      },
    );
  }

  // Cancel the order
  Future<void> _cancelOrder(OrderModel order) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final success = await _orderService.updateOrderStatus(order.id, 'Cancelled');
      
      if (!mounted) return;
      
      if (success) {
        // Refresh orders list
        await _loadOrders();
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Your order for ${order.coffeeName} has been cancelled'),
            backgroundColor: Colors.green[600],
          ),
        );
      } else {
        setState(() {
          _isLoading = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to cancel order. Please try again.'),
            backgroundColor: Colors.red[600],
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      
      setState(() {
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error cancelling order: ${e.toString()}'),
          backgroundColor: Colors.red[600],
        ),
      );
    }
  }
} 