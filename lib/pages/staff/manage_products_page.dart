import 'package:flutter/material.dart';
import 'package:flutter_activity1/models/productModel.dart';
import 'package:flutter_activity1/services/product_service.dart';
import 'package:flutter_activity1/widgets/app_drawer.dart';
import 'package:flutter_activity1/pages/staff/edit_product_page.dart';

class ManageProductsPage extends StatefulWidget {
  static const String routeName = '/manage-products';

  const ManageProductsPage({super.key});

  @override
  State<ManageProductsPage> createState() => _ManageProductsPageState();
}

class _ManageProductsPageState extends State<ManageProductsPage> {
  final ProductService _productService = ProductService();
  List<ProductModel> _products = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final products = await _productService.getAllProducts();
      
      if (!mounted) return;
      setState(() {
        _products = products;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading products: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'RETRY',
            onPressed: _loadProducts,
            textColor: Colors.white,
          ),
        ),
      );
    }
  }

  List<ProductModel> get _filteredProducts {
    return _products.where((product) {
      // Filter by search query
      final matchesQuery = _searchQuery.isEmpty ||
          product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          product.description.toLowerCase().contains(_searchQuery.toLowerCase());
      
      return matchesQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E6D3),
      appBar: AppBar(
        title: const Text("Manage Products"),
        centerTitle: true,
        backgroundColor: Colors.brown[800],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadProducts,
            tooltip: 'Refresh',
          ),
        ],
      ),
      drawer: const AppDrawer(currentRoute: '/manage-products'),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EditProductPage(),
            ),
          );
          if (result == true) {
            _loadProducts();
          }
        },
        backgroundColor: Colors.brown[700],
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.brown))
          : _buildResponsiveLayout(),
    );
  }

  Widget _buildResponsiveLayout() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1100) {
          // Desktop layout
          return _buildDesktopLayout();
        } else if (constraints.maxWidth >= 650) {
          // Tablet layout
          return _buildTabletLayout();
        } else {
          // Mobile layout
          return _buildMobileLayout();
        }
      },
    );
  }

  Widget _buildDesktopLayout() {
    if (_products.isEmpty) {
      return _buildEmptyState();
    }
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Side panel with filters
        Container(
          width: 280,
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.brown.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchField(),
                const SizedBox(height: 24),
                _buildProductStatistics(),
              ],
            ),
          ),
        ),
        // Products grid
        Expanded(
          child: _buildProductsGrid(crossAxisCount: 3, aspectRatio: 1.2),
        ),
      ],
    );
  }

  Widget _buildTabletLayout() {
    if (_products.isEmpty) {
      return _buildEmptyState();
    }
    
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: _buildSearchField(),
        ),
        Expanded(
          child: _buildProductsGrid(crossAxisCount: 2, aspectRatio: 1.3),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    if (_products.isEmpty) {
      return _buildEmptyState();
    }
    
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: _buildSearchField(),
        ),
        Expanded(
          child: _filteredProducts.isEmpty
              ? _buildNoResultsFound()
              : _buildProductsList(),
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search products...',
        prefixIcon: const Icon(Icons.search, color: Colors.brown),
        filled: true,
        fillColor: Colors.brown[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 0),
      ),
      onChanged: (value) {
        setState(() {
          _searchQuery = value;
        });
      },
    );
  }

  Widget _buildProductStatistics() {
    final available = _products.where((p) => p.isAvailable).length;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Product Statistics",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.brown[800],
          ),
        ),
        const SizedBox(height: 16),
        _buildStatItem(
          title: "Total Products",
          value: "${_products.length}",
          icon: Icons.inventory_2,
          color: Colors.blue[700]!,
        ),
        const SizedBox(height: 12),
        _buildStatItem(
          title: "Available",
          value: "$available",
          icon: Icons.check_circle,
          color: Colors.green[600]!,
        ),
        const SizedBox(height: 12),
        _buildStatItem(
          title: "Unavailable",
          value: "${_products.length - available}",
          icon: Icons.cancel,
          color: Colors.red[400]!,
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
            size: 16,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 14,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.brown[800],
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildProductsGrid({required int crossAxisCount, required double aspectRatio}) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: _filteredProducts.isEmpty
          ? _buildNoResultsFound()
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: aspectRatio,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _filteredProducts.length,
              itemBuilder: (context, index) {
                return _buildProductCard(_filteredProducts[index]);
              },
            ),
    );
  }

  Widget _buildProductsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredProducts.length,
      itemBuilder: (context, index) {
        final product = _filteredProducts[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
          child: InkWell(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProductPage(product: product),
                ),
              );
              if (result == true) {
                _loadProducts();
              }
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      product.imagePath,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                product.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.brown,
                                ),
                              ),
                            ),
                            Switch(
                              value: product.isAvailable,
                              onChanged: (newValue) async {
                                final success = await _productService.toggleProductAvailability(
                                  product.id,
                                  newValue,
                                );
                                if (!mounted) return;
                                if (success) {
                                  _loadProducts();
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Failed to update availability'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                              activeColor: Colors.brown[700],
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          product.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.brown[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.brown[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "₱${product.basePrice.toStringAsFixed(2)}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.brown[800],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductCard(ProductModel product) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditProductPage(product: product),
            ),
          );
          if (result == true) {
            _loadProducts();
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image with availability indicator
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: Image.asset(
                    product.imagePath,
                    width: double.infinity,
                    height: 160,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: product.isAvailable ? Colors.green[600] : Colors.red[400],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      product.isAvailable ? "Available" : "Unavailable",
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
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.amber[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "₱${product.basePrice.toStringAsFixed(2)}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.brown[800],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.brown[600],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProductPage(product: product),
                            ),
                          );
                          if (result == true) {
                            _loadProducts();
                          }
                        },
                        icon: const Icon(Icons.edit, size: 16),
                        label: const Text("Edit"),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.brown[700],
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                      ),
                      Switch(
                        value: product.isAvailable,
                        onChanged: (newValue) async {
                          final success = await _productService.toggleProductAvailability(
                            product.id,
                            newValue,
                          );
                          if (!mounted) return;
                          if (success) {
                            _loadProducts();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Failed to update availability'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        activeColor: Colors.brown[700],
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
            'Add some coffee products to get started',
            style: TextStyle(
              fontSize: 16,
              color: Colors.brown[600],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditProductPage(),
                ),
              );
              if (result == true) {
                _loadProducts();
              }
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Product'),
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

  Widget _buildNoResultsFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.brown[300],
          ),
          const SizedBox(height: 16),
          Text(
            'No matching products found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.brown[700],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search',
            style: TextStyle(
              fontSize: 14,
              color: Colors.brown[600],
            ),
          ),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: () {
              setState(() {
                _searchQuery = '';
              });
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Clear Search'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.brown[700],
            ),
          ),
        ],
      ),
    );
  }
} 