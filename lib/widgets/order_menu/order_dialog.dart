import 'package:flutter/material.dart';
import 'package:flutter_activity1/models/orderItemModel.dart';
import 'package:flutter_activity1/models/productModel.dart';
import 'package:flutter_activity1/models/specialModel.dart';
import 'dart:math';

class OrderDialog extends StatefulWidget {
  final ProductModel product;
  final Map<String, dynamic>? discountInfo;
  final Function(OrderItemModel) onAddToCart;

  const OrderDialog({
    super.key,
    required this.product,
    this.discountInfo,
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
  
  // Get discount information
  bool get hasDiscount => widget.discountInfo?['hasDiscount'] == true;
  double get originalPrice => widget.product.basePrice;
  double get discountedBasePrice => hasDiscount ? widget.discountInfo!['finalPrice'] : originalPrice;
  SpecialModel? get special => widget.discountInfo?['special'];

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
    double basePrice = discountedBasePrice;
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
      basePrice: discountedBasePrice, // Use discounted base price
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
                // Special badge if applicable
                if (hasDiscount)
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.local_offer,
                            size: 16,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            special!.getDiscountDescription(),
                            style: const TextStyle(
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
                      if (hasDiscount)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Base: ₱${originalPrice.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 14,
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              'Special: ₱${discountedBasePrice.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.red[700],
                              ),
                            ),
                          ],
                        )
                      else
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
                      labelStyle: TextStyle(
                        color: showSizeError ? Colors.red : Colors.brown,
                        fontWeight: FontWeight.bold,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: showSizeError ? Colors.red : Colors.brown,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: showSizeError ? Colors.red : Colors.brown,
                        ),
                      ),
                      errorText: showSizeError ? 'Please select a size' : null,
                    ),
                    onChanged: (value) {
                      setState(() {
                        selectedSize = value;
                        showSizeError = false;
                      });
                    },
                    items: widget.product.sizes.map((size) {
                      return DropdownMenuItem<String>(
                        value: size['name'] as String,
                        child: Text(
                          '${size['name']} (+₱${size['price'].toStringAsFixed(2)})',
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Add-ons Selection
                  DropdownButtonFormField<String>(
                    value: selectedAddOn,
                    decoration: InputDecoration(
                      labelText: 'Add-ons (Optional)',
                      labelStyle: const TextStyle(
                        color: Colors.brown,
                        fontWeight: FontWeight.bold,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        selectedAddOn = value;
                      });
                    },
                    items: [
                      const DropdownMenuItem<String>(
                        value: null,
                        child: Text('None'),
                      ),
                      ...widget.product.addOns.map((addOn) {
                        return DropdownMenuItem<String>(
                          value: addOn['name'] as String,
                          child: Text(
                            '${addOn['name']} (+₱${addOn['price'].toStringAsFixed(2)})',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Total Price and Add to Cart Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Total Price:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.brown,
                            ),
                          ),
                          Text(
                            '₱${totalPrice.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: hasDiscount ? Colors.red[700] : Colors.brown[700],
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton.icon(
                        onPressed: _handleAddToCart,
                        icon: const Icon(Icons.add_shopping_cart),
                        label: const Text('Add to Cart'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown[700],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
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