import 'package:flutter/material.dart';
import 'package:flutter_activity1/models/orderItemModel.dart';
import 'package:flutter_activity1/models/productModel.dart';
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
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isLargeScreen = screenWidth >= 1100;
    final bool isMediumScreen = screenWidth >= 768 && screenWidth < 1100;
    final bool isSmallScreen = screenWidth < 768;
    final double horizontalPadding = isSmallScreen ? 16 : isLargeScreen ? 24 : 20;
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
      child: _isLoading
          ? _buildLoadingState()
          : _products.isEmpty
              ? _buildEmptyState()
              : _buildProductsGrid(isSmallScreen, isMediumScreen, isLargeScreen),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          CircularProgressIndicator(color: Colors.brown[600]),
          const SizedBox(height: 24),
          Text(
            'Loading our delicious menu...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.brown[700],
              fontWeight: FontWeight.w500,
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
            child: Icon(
              Icons.coffee,
              size: 80,
              color: Colors.brown[300],
            ),
          ),
          const SizedBox(height: 24),
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

  Widget _buildProductsGrid(bool isSmallScreen, bool isMediumScreen, bool isLargeScreen) {
    // Determine number of columns based on screen size
    int crossAxisCount;
    final screenWidth = MediaQuery.of(context).size.width;
    
    if (isLargeScreen) {
      crossAxisCount = 3;
    } else if (isMediumScreen) {
      crossAxisCount = 2;
    } else {
      crossAxisCount = screenWidth < 480 ? 1 : 2;
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Only show this section if there are products with discounts
        if (_productDiscounts.values.any((discount) => discount['hasDiscount'] == true))
          _buildDiscountBanner(),
        
        const SizedBox(height: 16),
        
        
        const SizedBox(height: 5),
        
        // Wrap GridView in a LayoutBuilder to calculate exact dimensions
        LayoutBuilder(
          builder: (context, constraints) {
            // Recalculate aspect ratio based on exact available width
            final double itemWidth = (constraints.maxWidth - ((crossAxisCount - 1) * 16)) / crossAxisCount;
            final double idealHeight = screenWidth < 480 ? 290 : 360; // Target height
            final double finalAspectRatio = itemWidth / idealHeight;
            
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: finalAspectRatio,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                final discountInfo = _productDiscounts[product.id];
                return _buildProductCard(context, product, discountInfo);
              },
            );
          }
        ),
      ],
    );
  }
  
  Widget _buildDiscountBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.amber.shade100, Colors.amber.shade200],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.amber.shade600,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.local_offer, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Special offers available!',
                  style: TextStyle(
                    color: Colors.brown[800],
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Discounts are automatically applied to your order',
                  style: TextStyle(
                    color: Colors.brown[600],
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, ProductModel product, Map<String, dynamic>? discountInfo) {
    final bool hasDiscount = discountInfo?['hasDiscount'] == true;
    final double originalPrice = product.basePrice;
    final double finalPrice = discountInfo?['finalPrice'] ?? originalPrice;
    final dynamic appliedSpecial = discountInfo?['appliedSpecial'];
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isSmallScreen = screenWidth < 600;
    
    return GestureDetector(
      onTap: () => _showOrderDialog(context, product, discountInfo),
      child: Card(
        elevation: 4,
        shadowColor: Colors.brown.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image with discount badge if applicable
            Stack(
              children: [
                Hero(
                  tag: 'product_${product.id}',
                  child: Container(
                    height: isSmallScreen ? 120 : 160,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      image: DecorationImage(
                        image: AssetImage(product.imagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                if (hasDiscount && appliedSpecial != null)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.red[600],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        appliedSpecial.discountType == 'percentage'
                            ? '${appliedSpecial.discountValue.toInt()}% OFF'
                            : '₱${appliedSpecial.discountValue.toInt()} OFF',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            
            // Product details
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 16 : 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: isSmallScreen ? 4 : 6),
                    Text(
                      product.description,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 12 : 13,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Price display with discount if applicable
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (hasDiscount) ...[
                              Text(
                                '₱${originalPrice.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 11 : 12,
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.grey[500],
                                ),
                              ),
                              SizedBox(height: isSmallScreen ? 1 : 2),
                            ],
                            Text(
                              '₱${finalPrice.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: isSmallScreen ? 16 : 18,
                                fontWeight: FontWeight.bold,
                                color: hasDiscount ? Colors.red[700] : Colors.brown[700],
                              ),
                            ),
                          ],
                        ),
                        
                        // Add to cart button
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.brown[700],
                            borderRadius: BorderRadius.circular(isSmallScreen ? 10 : 12),
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.add_shopping_cart, 
                              color: Colors.white,
                              size: isSmallScreen ? 18 : 24,
                            ),
                            onPressed: () => _showOrderDialog(context, product, discountInfo),
                            tooltip: 'Add to cart',
                            padding: EdgeInsets.all(isSmallScreen ? 6 : 8),
                            constraints: const BoxConstraints(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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