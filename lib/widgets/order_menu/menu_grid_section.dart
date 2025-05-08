import 'package:flutter/material.dart';
import 'package:flutter_activity1/models/orderItemModel.dart';
import 'package:flutter_activity1/models/productModel.dart';
import 'package:flutter_activity1/services/product_service.dart';
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
  List<ProductModel> _products = [];
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
    });

    try {
      final products = await _productService.getAvailableProducts();
      if (mounted) {
        setState(() {
          _products = products;
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
        basePrice: 2.99,
        isAvailable: true,
        sizes: [
          {'name': 'Small', 'price': 0.0},
          {'name': 'Medium', 'price': 0.5},
          {'name': 'Large', 'price': 1.0},
        ],
        addOns: [
          {'name': 'Extra Shot (+₱0.50)', 'price': 0.5},
          {'name': 'Whipped Cream (+₱0.50)', 'price': 0.5},
          {'name': 'Caramel Drizzle (+₱0.30)', 'price': 0.3},
          {'name': 'Chocolate Sauce (+₱0.30)', 'price': 0.3},
        ],
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        id: '2',
        name: 'Cappuccino',
        description: 'Equal parts espresso, steamed milk, and milk foam',
        imagePath: 'assets/coffees/capuccino.jpg',
        basePrice: 4.49,
        isAvailable: true,
        sizes: [
          {'name': 'Small', 'price': 0.0},
          {'name': 'Medium', 'price': 0.5},
          {'name': 'Large', 'price': 1.0},
        ],
        addOns: [
          {'name': 'Extra Shot (+₱0.50)', 'price': 0.5},
          {'name': 'Whipped Cream (+₱0.50)', 'price': 0.5},
          {'name': 'Caramel Drizzle (+₱0.30)', 'price': 0.3},
          {'name': 'Chocolate Sauce (+₱0.30)', 'price': 0.3},
        ],
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        id: '3',
        name: 'Latte',
        description: 'Espresso with steamed milk and light foam',
        imagePath: 'assets/coffees/latte.jpg',
        basePrice: 4.29,
        isAvailable: true,
        sizes: [
          {'name': 'Small', 'price': 0.0},
          {'name': 'Medium', 'price': 0.5},
          {'name': 'Large', 'price': 1.0},
        ],
        addOns: [
          {'name': 'Extra Shot (+₱0.50)', 'price': 0.5},
          {'name': 'Whipped Cream (+₱0.50)', 'price': 0.5},
          {'name': 'Caramel Drizzle (+₱0.30)', 'price': 0.3},
          {'name': 'Chocolate Sauce (+₱0.30)', 'price': 0.3},
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
    return GridView.builder(
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
        return _buildProductCard(context, product);
      },
    );
  }

  Widget _buildProductCard(BuildContext context, ProductModel product) {
    return GestureDetector(
      onTap: () => _showOrderDialog(context, product),
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
                  product.imagePath,
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
                    product.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '₱${product.basePrice.toStringAsFixed(2)}',
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

  void _showOrderDialog(BuildContext context, ProductModel product) {
    showDialog(
      context: context,
      builder: (context) => OrderDialog(
        product: product,
        onAddToCart: widget.onAddToCart,
      ),
    );
  }
} 