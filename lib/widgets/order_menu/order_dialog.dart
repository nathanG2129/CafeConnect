import 'package:flutter/material.dart';
import 'package:flutter_activity1/models/orderItemModel.dart';
import 'package:flutter_activity1/models/productModel.dart';
import 'dart:math';

class OrderDialog extends StatefulWidget {
  final ProductModel product;
  final Function(OrderItemModel) onAddToCart;

  const OrderDialog({
    super.key,
    required this.product,
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

  // Get price modifiers
  double getSizePrice(String? size) {
    if (size == null) return 0.0;
    final sizeOption = widget.product.sizes.firstWhere(
      (s) => s['name'] == size,
      orElse: () => {'name': '', 'price': 0.0},
    );
    return sizeOption['price'];
  }

  double getAddOnPrice(String? addOn) {
    if (addOn == null) return 0.0;
    final addOnOption = widget.product.addOns.firstWhere(
      (a) => a['name'] == addOn,
      orElse: () => {'name': '', 'price': 0.0},
    );
    return addOnOption['price'];
  }

  double get totalPrice {
    double basePrice = widget.product.basePrice;
    basePrice += getSizePrice(selectedSize);
    basePrice += getAddOnPrice(selectedAddOn);
    return basePrice * quantity;
  }

  void _handleAddToCart() {
    if (selectedSize == null) {
      setState(() {
        showSizeError = true;
      });
      return;
    }

    // Generate a unique item ID
    final String itemId = 'item_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(1000)}';

    // Create an OrderItemModel
    final OrderItemModel orderItem = OrderItemModel(
      id: itemId,
      coffeeName: widget.product.name,
      size: selectedSize!,
      addOn: selectedAddOn,
      quantity: quantity,
      basePrice: widget.product.basePrice,
      totalPrice: totalPrice,
      imagePath: widget.product.imagePath,
    );

    // Add to cart
    widget.onAddToCart(orderItem);

    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Added ${quantity}x ${widget.product.name} ($selectedSize)${selectedAddOn != null ? ' with $selectedAddOn' : ''} to cart',
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
                    widget.product.imagePath,
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
                          widget.product.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          'Base: ₱${widget.product.basePrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.brown[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.product.description,
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
                      helperText: 'Select a size for your beverage',
                    ),
                    items: widget.product.sizes.map((Map<String, dynamic> size) {
                      final name = size['name'];
                      final price = size['price'] as double;
                      return DropdownMenuItem<String>(
                        value: name,
                        child: Text('$name ${price > 0 ? "(+₱${price.toStringAsFixed(2)})" : ""}'),
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
                    items: widget.product.addOns.map((Map<String, dynamic> addOn) {
                      final name = addOn['name'];
                      final price = addOn['price'] as double;
                      return DropdownMenuItem<String>(
                        value: name,
                        child: Text('$name (+₱${price.toStringAsFixed(2)})'),
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
                          '₱${totalPrice.toStringAsFixed(2)}',
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