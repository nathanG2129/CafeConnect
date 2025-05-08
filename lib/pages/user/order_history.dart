import 'package:flutter/material.dart';
import 'package:flutter_activity1/models/orderModel.dart';
import 'package:flutter_activity1/services/order_service.dart';
import 'package:flutter_activity1/models/cartModel.dart';
import 'package:intl/intl.dart';
import '../../widgets/app_drawer.dart';
import 'package:flutter_activity1/models/orderItemModel.dart';

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
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isLargeScreen = screenWidth >= 1100;
    final bool isMediumScreen = screenWidth >= 768 && screenWidth < 1100;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF5E6D3),
      appBar: AppBar(
        title: const Text("Order History"),
        centerTitle: true,
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadOrders,
            tooltip: 'Refresh orders',
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
                  : isLargeScreen
                      ? _buildDesktopLayout()
                      : isMediumScreen
                          ? _buildTabletLayout()
                          : _buildMobileLayout(),
    );
  }

  Widget _buildDesktopLayout() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Side panel with order dates
          Container(
            width: 300,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.brown.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: _buildOrderDateList(),
          ),
          const SizedBox(width: 24),
          // Expanded area for order cards
          Expanded(
            child: _buildOrderList(isCompact: false),
          ),
        ],
      ),
    );
  }

  Widget _buildTabletLayout() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: _buildOrderList(isCompact: false),
    );
  }

  Widget _buildMobileLayout() {
    return _buildOrderList(isCompact: true);
  }

  Widget _buildOrderDateList() {
    // Group orders by date
    final Map<String, List<OrderModel>> groupedOrders = _groupOrdersByDate();
    final List<String> dates = groupedOrders.keys.toList();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            'Order Dates',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.brown[800],
            ),
          ),
        ),
        const Divider(),
        Expanded(
          child: ListView.builder(
            itemCount: dates.length,
            itemBuilder: (context, index) {
              final date = dates[index];
              final ordersCount = groupedOrders[date]!.length;
              
              return ListTile(
                leading: Icon(Icons.calendar_today, color: Colors.brown[600]),
                title: Text(date),
                subtitle: Text('$ordersCount ${ordersCount == 1 ? 'order' : 'orders'}'),
                trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.brown[400]),
                onTap: () {
                  // Scroll to this date in the main view
                  // This would need a more complex implementation with scroll controllers
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.brown[600]),
          const SizedBox(height: 24),
          Text(
            'Loading your orders...',
            style: TextStyle(
              color: Colors.brown[700], 
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
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
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red[50],
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
          ),
          const SizedBox(height: 24),
          Text(
            'Failed to load orders',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.brown[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please check your connection and try again',
            style: TextStyle(
              fontSize: 16,
              color: Colors.brown[600],
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _loadOrders,
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.brown[50],
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.receipt_long, size: 64, color: Colors.brown[300]),
          ),
          const SizedBox(height: 24),
          Text(
            'No Order History',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.brown[800],
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'You haven\'t placed any orders yet. Start by ordering your favorite coffee!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.brown[600],
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => Navigator.pushReplacementNamed(context, '/menu'),
            icon: const Icon(Icons.coffee),
            label: const Text('Browse Menu'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.brown[700],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to group orders by date
  Map<String, List<OrderModel>> _groupOrdersByDate() {
    final Map<String, List<OrderModel>> groupedOrders = {};
    
    for (var order in _orders) {
      final dateStr = DateFormat('MMMM d, yyyy').format(order.orderDate);
      if (!groupedOrders.containsKey(dateStr)) {
        groupedOrders[dateStr] = [];
      }
      groupedOrders[dateStr]!.add(order);
    }
    
    return groupedOrders;
  }

  Widget _buildOrderList({required bool isCompact}) {
    // Group orders by date
    final groupedOrders = _groupOrdersByDate();

    return ListView.builder(
      padding: EdgeInsets.all(isCompact ? 12 : 16),
      itemCount: groupedOrders.length,
      itemBuilder: (context, index) {
        final date = groupedOrders.keys.elementAt(index);
        final dateOrders = groupedOrders[date]!;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Colors.brown[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.brown.withOpacity(0.1)),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today, size: 18, color: Colors.brown[600]),
                  const SizedBox(width: 8),
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown[800],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.brown[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${dateOrders.length} ${dateOrders.length == 1 ? 'order' : 'orders'}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.brown[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ...dateOrders.map((order) => _buildOrderCard(order, isCompact)).toList(),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  Widget _buildOrderCard(OrderModel order, bool isCompact) {
    final timeStr = DateFormat('h:mm a').format(order.orderDate);
    final screenWidth = MediaQuery.of(context).size.width;
    
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
        padding: EdgeInsets.all(isCompact ? 12 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order header with time and status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #${order.id.substring(order.id.length - 5)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
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
            
            // Status indicator
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
            const SizedBox(height: 16),
            
            // List of items in this order - use compact view for small screens
            if (isCompact && screenWidth < 400)
              _buildCompactItemsList(order.items)
            else if (isCompact)
              ...order.items.map((item) => _buildCompactOrderItemTile(item)).toList()
            else
              ...order.items.map((item) => _buildOrderItemTile(item)).toList(),
            
            const Divider(height: 24),
            
            // Order summary - adapt layout based on screen size
            screenWidth > 600
                ? _buildWideOrderSummary(order)
                : _buildCompactOrderSummary(order),
            
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _reorderAllItems(order),
                    icon: const Icon(Icons.replay),
                    label: const Text('Reorder All'),
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

  // Helper method for very small screens to show items as a simple summary
  Widget _buildCompactItemsList(List<OrderItemModel> items) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.brown[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${items.length} ${items.length == 1 ? 'item' : 'items'}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.brown[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            items.map((item) => '${item.quantity}x ${item.coffeeName}').join(', '),
            style: TextStyle(
              color: Colors.brown[700],
              fontSize: 13,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // Helper method to build a compact order item tile for smaller screens
  Widget _buildCompactOrderItemTile(OrderItemModel item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
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
          const SizedBox(width: 8),
          
          // Item details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.coffeeName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                Text(
                  'Size: ${item.size}${item.addOn != null ? ' • ${item.addOn}' : ''}',
                  style: TextStyle(
                    fontSize: 11,
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
                  fontSize: 12,
                  color: Colors.brown[700],
                ),
              ),
              Text(
                '₱${item.totalPrice.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 13,
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

  // Helper method to build a single order item tile
  Widget _buildOrderItemTile(OrderItemModel item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Item image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              item.imagePath,
              width: 50,
              height: 50,
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
                  fontSize: 16,
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

  // Wide order summary for larger screens
  Widget _buildWideOrderSummary(OrderModel order) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              _buildSummaryRow('Subtotal:', '₱${order.subtotal.toStringAsFixed(2)}'),
              const SizedBox(height: 4),
              _buildSummaryRow('Tax:', '₱${order.tax.toStringAsFixed(2)}'),
            ],
          ),
        ),
        const SizedBox(width: 24),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.brown[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.brown.withOpacity(0.1)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Total:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown[800],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '₱${order.totalAmount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown[700],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Compact order summary for smaller screens
  Widget _buildCompactOrderSummary(OrderModel order) {
    return Column(
      children: [
        _buildSummaryRow('Subtotal:', '₱${order.subtotal.toStringAsFixed(2)}'),
        const SizedBox(height: 4),
        _buildSummaryRow('Tax:', '₱${order.tax.toStringAsFixed(2)}'),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Total:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '₱${order.totalAmount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.brown[700],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Helper for building summary rows
  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.brown[700]),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.brown[700],
          ),
        ),
      ],
    );
  }

  void _reorderAllItems(OrderModel order) {
    // Add all items to cart before navigating
    final cartModel = CartModel();
    cartModel.loadFromStorage();
    
    // Add each item in the order to the cart
    for (var item in order.items) {
      cartModel.addItem(item);
    }
    
    // Navigate to menu page with a flag to open the cart
    Navigator.pushReplacementNamed(
      context, 
      '/menu',
      arguments: {'openCart': true}
    );
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Order added to cart'),
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
                const Text('Are you sure you want to cancel your order?'),
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
        
        if (!mounted) return;
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Your order has been cancelled'),
            backgroundColor: Colors.green[600],
          ),
        );
      } else {
        setState(() {
          _isLoading = false;
        });
        
        if (!mounted) return;
        
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