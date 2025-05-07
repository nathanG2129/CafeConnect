import 'package:flutter/material.dart';
import 'package:flutter_activity1/models/orderModel.dart';
import 'dart:math';

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