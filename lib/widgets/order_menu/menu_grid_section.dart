import 'package:flutter/material.dart';
import 'package:flutter_activity1/models/orderItemModel.dart';
import 'package:flutter_activity1/models/productModel.dart';
import 'package:flutter_activity1/models/specialModel.dart';
import 'package:flutter_activity1/services/product_service.dart';
import 'package:flutter_activity1/services/discount_service.dart';
import 'package:flutter_activity1/widgets/order_menu/order_dialog.dart';

class MenuGridSection extends StatefulWidget {
  final Function(OrderItemModel) onAddToCart;

  const MenuGridSection({
    super.key,
    required this.onAddToCart,
  });

  @override
  State<MenuGridSection> createState() => _MenuGridSectionState();
}

class _MenuGridSectionState extends State<MenuGridSection> {
  final ProductService _productService = ProductService();
  final DiscountService _discountService = DiscountService();
  List<ProductModel> _products = [];
  Map<String, Map<String, dynamic>> _productDiscounts = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _productDiscounts = {};
    });

    try {
      final products = await _productService.getAvailableProducts();
      
      // Calculate discounts for each product
      final Map<String, Map<String, dynamic>> discounts = {};
      for (var product in products) {
        discounts[product.id] = await _discountService.calculateDiscountedPrice(product);
      }
      
      if (mounted) {
        setState(() {
          _products = products;
          _productDiscounts = discounts;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _products = _getFallbackProducts(); // Use fallback if Firebase fails
        });
      }
    }
  }

  // Fallback products if Firebase is unavailable
  List<ProductModel> _getFallbackProducts() {
    final DateTime now = DateTime.now();
    return [
      ProductModel(
        id: '1',
        name: 'Espresso',
        description: 'Strong and concentrated coffee shot',
        imagePath: 'assets/coffees/expresso.jpg',
        basePrice: 89.0,
        isAvailable: true,
        sizes: [
          {'name': 'Small', 'price': 0.0},
          {'name': 'Medium', 'price': 20.0},
          {'name': 'Large', 'price': 35.0},
        ],
        addOns: [
          {'name': 'Extra Shot', 'price': 20.0},
          {'name': 'Whipped Cream', 'price': 15.0},
          {'name': 'Caramel Drizzle', 'price': 10.0},
          {'name': 'Chocolate Sauce', 'price': 10.0},
        ],
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        id: '2',
        name: 'Cappuccino',
        description: 'Equal parts espresso, steamed milk, and milk foam',
        imagePath: 'assets/coffees/capuccino.jpg',
        basePrice: 119.0,
        isAvailable: true,
        sizes: [
          {'name': 'Small', 'price': 0.0},
          {'name': 'Medium', 'price': 20.0},
          {'name': 'Large', 'price': 35.0},
        ],
        addOns: [
          {'name': 'Extra Shot', 'price': 20.0},
          {'name': 'Whipped Cream', 'price': 15.0},
          {'name': 'Caramel Drizzle', 'price': 10.0},
          {'name': 'Chocolate Sauce', 'price': 10.0},
        ],
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        id: '3',
        name: 'Latte',
        description: 'Espresso with steamed milk and light foam',
        imagePath: 'assets/coffees/latte.jpg',
        basePrice: 109.0,
        isAvailable: true,
        sizes: [
          {'name': 'Small', 'price': 0.0},
          {'name': 'Medium', 'price': 20.0},
          {'name': 'Large', 'price': 35.0},
        ],
        addOns: [
          {'name': 'Extra Shot', 'price': 20.0},
          {'name': 'Whipped Cream', 'price': 15.0},
          {'name': 'Caramel Drizzle', 'price': 10.0},
          {'name': 'Chocolate Sauce', 'price': 10.0},
        ],
        createdAt: now,
        updatedAt: now,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.brown))
          : _products.isEmpty
              ? _buildEmptyState()
              : _buildProductsGrid(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.coffee,
            size: 80,
            color: Colors.brown[300],
          ),
          const SizedBox(height: 16),
          Text(
            'No products available',
            style: TextStyle(
              fontSize: 20,
              color: Colors.brown[700],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please check back later',
            style: TextStyle(
              fontSize: 16,
              color: Colors.brown[600],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _loadProducts,
            icon: const Icon(Icons.refresh),
            label: const Text('Refresh'),
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

  Widget _buildProductsGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Only show this section if there are products with discounts
        if (_productDiscounts.values.any((discount) => discount['hasDiscount'] == true))
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.local_offer, color: Colors.amber[800], size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Special offers automatically applied!',
                      style: TextStyle(
                        color: Colors.amber[900],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: _products.length,
          itemBuilder: (context, index) {
            final product = _products[index];
            final discountInfo = _productDiscounts[product.id];
            return _buildProductCard(context, product, discountInfo);
          },
        ),
      ],
    );
  }

  Widget _buildProductCard(BuildContext context, ProductModel product, Map<String, dynamic>? discountInfo) {
    final bool hasDiscount = discountInfo?['hasDiscount'] == true;
    final double originalPrice = product.basePrice;
    final double finalPrice = discountInfo?['finalPrice'] ?? originalPrice;
    final SpecialModel? special = discountInfo?['special'];
    
    return GestureDetector(
      onTap: () => _showOrderDialog(context, product, discountInfo),
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
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.asset(
                    product.imagePath,
                    width: double.infinity,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                if (hasDiscount)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        special!.getDiscountDescription(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Show original price strikethrough and discounted price
                  if (hasDiscount) ...[
                    Row(
                      children: [
                        Text(
                          '₱${originalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 12,
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '₱${finalPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.red[700],
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    Text(
                      '₱${product.basePrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown[700],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOrderDialog(BuildContext context, ProductModel product, Map<String, dynamic>? discountInfo) {
    showDialog(
      context: context,
      builder: (context) => OrderDialog(
        product: product,
        discountInfo: discountInfo,
        onAddToCart: widget.onAddToCart,
      ),
    );
  }
} 