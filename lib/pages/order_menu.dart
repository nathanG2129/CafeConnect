import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import 'package:flutter_activity1/models/cartModel.dart';
import 'package:flutter_activity1/models/orderModel.dart';
import 'package:flutter_activity1/services/order_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';

class OrderMenuPage extends StatefulWidget {
  const OrderMenuPage({super.key});

  @override
  State<OrderMenuPage> createState() => _OrderMenuPageState();
}

class _OrderMenuPageState extends State<OrderMenuPage> {
  final CartModel _cart = CartModel();
  bool _isCartOpen = false;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  void _loadCart() {
    _cart.loadFromStorage();
    setState(() {});
  }

  void _toggleCart() {
    setState(() {
      _isCartOpen = !_isCartOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E6D3),
      appBar: AppBar(
        title: const Text("Order Menu"),
        centerTitle: true,
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: _toggleCart,
              ),
              if (_cart.itemCount > 0)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      _cart.itemCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: _isCartOpen
          ? CartView(
              cart: _cart,
              onClose: _toggleCart,
              onUpdate: () => setState(() {}),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  const HeaderSection(),
                  MenuGridSection(
                    onAddToCart: (OrderModel order) {
                      setState(() {
                        _cart.addItem(order);
                      });
                    },
                  ),
                ],
              ),
            ),
    );
  }
}

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.brown[700],
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
      child: Column(
        children: [
          Icon(Icons.coffee_maker, color: Colors.amber[300], size: 48),
          const SizedBox(height: 16),
          const Text(
            "Place Your Order",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Tap on a coffee to customize your order",
            style: TextStyle(
              fontSize: 16,
              color: Colors.brown[100],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class MenuGridSection extends StatelessWidget {
  final Function(OrderModel) onAddToCart;

  const MenuGridSection({
    super.key,
    required this.onAddToCart,
  });

  final List<Map<String, dynamic>> coffees = const [
    {
      'name': 'Espresso',
      'image': 'assets/coffees/expresso.jpg',
      'price': 2.99,
      'description': 'Strong and concentrated coffee shot',
    },
    {
      'name': 'Cappuccino',
      'image': 'assets/coffees/capuccino.jpg',
      'price': 4.49,
      'description': 'Equal parts espresso, steamed milk, and milk foam',
    },
    {
      'name': 'Latte',
      'image': 'assets/coffees/latte.jpg',
      'price': 4.29,
      'description': 'Espresso with steamed milk and light foam',
    },
    {
      'name': 'Americano',
      'image': 'assets/coffees/americano.jpg',
      'price': 3.49,
      'description': 'Espresso diluted with hot water',
    },
    {
      'name': 'Mocha',
      'image': 'assets/coffees/mocha.jpg',
      'price': 4.49,
      'description': 'Espresso with chocolate and steamed milk',
    },
    {
      'name': 'Cold Brew',
      'image': 'assets/coffees/coldbrew.jpg',
      'price': 3.99,
      'description': 'Smooth, cold-steeped coffee',
    },
    {
      'name': 'Caramel Macchiato',
      'image': 'assets/coffees/macchiato.jpg',
      'price': 4.99,
      'description': 'Vanilla-flavored drink marked with espresso and caramel',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: coffees.length,
        itemBuilder: (context, index) {
          final coffee = coffees[index];
          return _buildCoffeeCard(context, coffee);
        },
      ),
    );
  }

  Widget _buildCoffeeCard(BuildContext context, Map<String, dynamic> coffee) {
    return GestureDetector(
      onTap: () => _showOrderDialog(context, coffee),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.brown.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.asset(
                  coffee['image'],
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    coffee['name'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${coffee['price'].toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown[700],
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

  void _showOrderDialog(BuildContext context, Map<String, dynamic> coffee) {
    showDialog(
      context: context,
      builder: (context) => OrderDialog(
        coffee: coffee,
        onAddToCart: onAddToCart,
      ),
    );
  }
}

class OrderDialog extends StatefulWidget {
  final Map<String, dynamic> coffee;
  final Function(OrderModel) onAddToCart;

  const OrderDialog({
    super.key,
    required this.coffee,
    required this.onAddToCart,
  });

  @override
  State<OrderDialog> createState() => _OrderDialogState();
}

class _OrderDialogState extends State<OrderDialog> {
  String? selectedSize;
  String? selectedAddOn;
  int quantity = 1;
  bool showSizeError = false;
  final List<String> sizes = ['Small', 'Medium', 'Large'];
  final List<String> addOns = [
    'Extra Shot (+\$0.50)',
    'Whipped Cream (+\$0.50)',
    'Caramel Drizzle (+\$0.30)',
    'Chocolate Sauce (+\$0.30)',
  ];

  // Price modifiers
  final Map<String, double> sizePrices = {
    'Small': 0.0,
    'Medium': 0.50,
    'Large': 1.00,
  };

  final Map<String, double> addOnPrices = {
    'Extra Shot (+\$0.50)': 0.50,
    'Whipped Cream (+\$0.50)': 0.50,
    'Caramel Drizzle (+\$0.30)': 0.30,
    'Chocolate Sauce (+\$0.30)': 0.30,
  };

  double get totalPrice {
    double basePrice = widget.coffee['price'];
    if (selectedSize != null) {
      basePrice += sizePrices[selectedSize]!;
    }
    if (selectedAddOn != null) {
      basePrice += addOnPrices[selectedAddOn]!;
    }
    return basePrice * quantity;
  }

  void _handleAddToCart() {
    if (selectedSize == null) {
      setState(() {
        showSizeError = true;
      });
      return;
    }

    // Generate a unique order ID
    final String orderId = 'order_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(1000)}';

    // Create an OrderModel
    final OrderModel order = OrderModel(
      id: orderId,
      coffeeName: widget.coffee['name'],
      size: selectedSize!,
      addOn: selectedAddOn,
      quantity: quantity,
      basePrice: widget.coffee['price'],
      totalPrice: totalPrice,
      imagePath: widget.coffee['image'],
      orderDate: DateTime.now(),
    );

    // Add to cart
    widget.onAddToCart(order);

    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Added ${quantity}x ${widget.coffee['name']} ($selectedSize)${selectedAddOn != null ? ' with $selectedAddOn' : ''} to cart',
        ),
        backgroundColor: Colors.green[600],
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'VIEW CART',
          textColor: Colors.white,
          onPressed: () {
            // Close dialog
            Navigator.pop(context);
          },
        ),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image Section
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.asset(
                    widget.coffee['image'],
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                // Required badge
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star,
                          size: 16,
                          color: Colors.amber[300],
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'Size Required',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Base Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.coffee['name'],
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown,
                          ),
                        ),
                      ),
                      Text(
                        'Base: \$${widget.coffee['price'].toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.brown[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.coffee['description'],
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.brown[600],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Quantity Selection
                  Row(
                    children: [
                      const Text(
                        'Quantity:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.brown),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: quantity > 1
                                  ? () => setState(() => quantity--)
                                  : null,
                              color: Colors.brown,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                quantity.toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: quantity < 10
                                  ? () => setState(() => quantity++)
                                  : null,
                              color: Colors.brown,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Size Selection with price indicators
                  DropdownButtonFormField<String>(
                    value: selectedSize,
                    decoration: InputDecoration(
                      labelText: 'Size *',
                      border: const OutlineInputBorder(),
                      errorText: showSizeError ? 'Please select a size' : null,
                      helperText: 'Price adjustments: Medium +\$0.50, Large +\$1.00',
                    ),
                    items: sizes.map((String size) {
                      return DropdownMenuItem<String>(
                        value: size,
                        child: Text('$size ${sizePrices[size]! > 0 ? "(+\$${sizePrices[size]!.toStringAsFixed(2)})" : ""}'),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        selectedSize = value;
                        showSizeError = false;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Add-ons Selection
                  DropdownButtonFormField<String>(
                    value: selectedAddOn,
                    decoration: const InputDecoration(
                      labelText: 'Add-ons (Optional)',
                      border: OutlineInputBorder(),
                      helperText: 'Customize your drink with extra toppings',
                    ),
                    items: addOns.map((String addOn) {
                      return DropdownMenuItem<String>(
                        value: addOn,
                        child: Text(addOn),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        selectedAddOn = value;
                      });
                    },
                  ),
                  const SizedBox(height: 24),

                  // Total Price Display
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.brown[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.brown[200]!),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Price:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown,
                          ),
                        ),
                        Text(
                          '\$${totalPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(color: Colors.brown[700]!),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.brown[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _handleAddToCart,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.brown[700],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Add to Cart',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
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
      ),
    );
  }
}

class CartView extends StatefulWidget {
  final CartModel cart;
  final VoidCallback onClose;
  final VoidCallback onUpdate;

  const CartView({
    super.key,
    required this.cart,
    required this.onClose,
    required this.onUpdate,
  });

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  final OrderService _orderService = OrderService();
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildCartHeader(),
        Expanded(
          child: widget.cart.items.isEmpty
              ? _buildEmptyCart()
              : _buildCartItems(),
        ),
        if (widget.cart.items.isNotEmpty) _buildCartFooter(),
      ],
    );
  }

  Widget _buildCartHeader() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.brown[700],
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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.shopping_cart, color: Colors.amber[300], size: 28),
                  const SizedBox(width: 12),
                  const Text(
                    "Your Cart",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: widget.onClose,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${widget.cart.itemCount} items",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.brown[100],
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (widget.cart.items.isNotEmpty)
                TextButton.icon(
                  onPressed: _confirmClearCart,
                  icon: const Icon(Icons.delete_outline, color: Colors.white),
                  label: const Text(
                    "Clear All",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: Colors.brown[300],
          ),
          const SizedBox(height: 16),
          Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 20,
              color: Colors.brown[700],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add some delicious coffee to your cart',
            style: TextStyle(
              fontSize: 16,
              color: Colors.brown[600],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: widget.onClose,
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

  Widget _buildCartItems() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: widget.cart.items.length,
      itemBuilder: (context, index) {
        final item = widget.cart.items[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    item.imagePath,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.coffeeName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Size: ${item.size}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.brown[600],
                        ),
                      ),
                      if (item.addOn != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          'Add-on: ${item.addOn}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.brown[600],
                          ),
                        ),
                      ],
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$${(item.totalPrice / item.quantity).toStringAsFixed(2)} each',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '\$${item.totalPrice.toStringAsFixed(2)}',
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
                ),
                const SizedBox(width: 8),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => _removeItem(item.id),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        SizedBox(
                          width: 28,
                          height: 28,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: Icon(Icons.remove, color: Colors.brown[700], size: 18),
                            onPressed: () => _updateQuantity(item.id, item.quantity - 1),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            item.quantity.toString(),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 28,
                          height: 28,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: Icon(Icons.add, color: Colors.brown[700], size: 18),
                            onPressed: () => _updateQuantity(item.id, item.quantity + 1),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCartFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.brown.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Subtotal:',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                '\$${widget.cart.totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tax (8%):',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                '\$${(widget.cart.totalPrice * 0.08).toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '\$${(widget.cart.totalPrice * 1.08).toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isProcessing ? null : _processOrder,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown[700],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isProcessing
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Checkout',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _removeItem(String itemId) {
    setState(() {
      widget.cart.removeItem(itemId);
    });
    widget.onUpdate();
  }

  void _updateQuantity(String itemId, int quantity) {
    setState(() {
      widget.cart.updateItemQuantity(itemId, quantity);
    });
    widget.onUpdate();
  }

  void _confirmClearCart() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cart'),
        content: const Text('Are you sure you want to clear all items from your cart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.brown[700]),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                widget.cart.clearCart();
              });
              widget.onUpdate();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  Future<void> _processOrder() async {
    // Check if user is logged in
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please log in to place an order'),
          backgroundColor: Colors.red[600],
          action: SnackBarAction(
            label: 'LOG IN',
            textColor: Colors.white,
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
          ),
        ),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      // Save each order item to Firestore
      bool allSuccessful = true;
      
      for (var item in widget.cart.items) {
        bool success = await _orderService.saveOrder(item);
        if (!success) {
          allSuccessful = false;
        }
      }

      setState(() {
        _isProcessing = false;
      });

      if (allSuccessful) {
        widget.cart.clearCart();
        widget.onUpdate();
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Order placed successfully!'),
            backgroundColor: Colors.green[600],
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('There was an issue processing your order'),
            backgroundColor: Colors.red[600],
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red[600],
        ),
      );
    }
  }
}