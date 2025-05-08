import 'package:flutter/material.dart';
import '../../widgets/app_drawer.dart';
import '../../models/specialModel.dart';
import '../../models/productModel.dart';
import '../../services/special_service.dart';
import '../../services/product_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E6D3),
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: true,
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      drawer: const AppDrawer(),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            TitleSection(),
            FeaturedDrinksSection(),
            DailySpecialsSection(),
          ],
        ),
      ),
    );
  }
}

class TitleSection extends StatelessWidget {
  const TitleSection({super.key});

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
            // ignore: deprecated_member_use
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.coffee, color: Colors.amber[300], size: 40),
              const SizedBox(width: 12),
              const Text(
                'CafeConnect',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Your Perfect Coffee Destination',
            style: TextStyle(
              color: Colors.brown[100],
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class FeaturedDrinksSection extends StatelessWidget {
  const FeaturedDrinksSection({super.key});

  final List<Map<String, dynamic>> featuredDrinks = const [
    {
      'name': 'Caramel Macchiato',
      'image': 'assets/coffees/macchiato.jpg',
      'price': '₱4.99',
    },
    {
      'name': 'Mocha',
      'image': 'assets/coffees/mocha.jpg',
      'price': '₱4.49',
    },
    {
      'name': 'Cold Brew',
      'image': 'assets/coffees/coldbrew.jpg',
      'price': '₱3.99',
    },
    {
      'name': 'Americano',
      'image': 'assets/coffees/americano.jpg',
      'price': '₱3.49',
    },
    {
      'name': 'Latte',
      'image': 'assets/coffees/latte.jpg',
      'price': '₱4.29',
    },
    {
      'name': 'Cappuccino',
      'image': 'assets/coffees/capuccino.jpg',
      'price': '₱4.49',
    },
    {
      'name': 'Espresso',
      'image': 'assets/coffees/expresso.jpg',
      'price': '₱2.99',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Featured Drinks',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.brown,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: featuredDrinks.length,
            itemBuilder: (context, index) {
              final drink = featuredDrinks[index];
              return _buildFeaturedDrinkCard(
                drink['name'],
                drink['image'],
                drink['price'],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedDrinkCard(String name, String image, String price) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16),
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
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              image,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  price,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.brown[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DailySpecialsSection extends StatefulWidget {
  const DailySpecialsSection({super.key});

  @override
  State<DailySpecialsSection> createState() => _DailySpecialsSectionState();
}

class _DailySpecialsSectionState extends State<DailySpecialsSection> {
  final SpecialService _specialService = SpecialService();
  final ProductService _productService = ProductService();
  
  bool _isLoading = true;
  List<SpecialModel> _specials = [];
  Map<String, ProductModel> _productsMap = {};
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadSpecials();
  }

  Future<void> _loadSpecials() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      // Get active specials
      final activeSpecials = await _specialService.getActiveSpecials(); 
      
      if (activeSpecials.isEmpty) {
        setState(() {
          _errorMessage = 'No active specials found';
          _isLoading = false;
        });
        return;
      }
      
      final productIds = activeSpecials
          .where((special) => special.productId != null)
          .map((special) => special.productId!)
          .toSet()
          .toList();
      
      // Load associated products if any
      Map<String, ProductModel> productsMap = {};
      if (productIds.isNotEmpty) {
        for (String productId in productIds) {
          final product = await _productService.getProductById(productId);
          if (product != null) {
            productsMap[productId] = product;
          }
        }
      }
      
      setState(() {
        _specials = activeSpecials;
        _productsMap = productsMap;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading specials: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
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
          Row(
            children: [
              Icon(Icons.local_offer, color: Colors.brown[700]),
              const SizedBox(width: 8),
              const Text(
                'Daily Specials',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
              const Spacer(),
              if (!_isLoading) 
                IconButton(
                  icon: const Icon(Icons.refresh, size: 20),
                  onPressed: _loadSpecials,
                  tooltip: 'Refresh specials',
                ),
            ],
          ),
          const SizedBox(height: 8),
          // Help text explaining that specials are automatically applied
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.amber[700], size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Specials are automatically applied when ordering!',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.amber[900],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.brown),
                )
              : _errorMessage != null
                  ? _buildErrorState()
                  : _specials.isEmpty
                      ? _buildEmptyState()
                      : Column(
                          children: _specials.map((special) => _buildSpecialItem(special)).toList(),
                        ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Icon(Icons.error_outline, color: Colors.orange, size: 40),
            const SizedBox(height: 8),
            Text(
              _errorMessage ?? 'Unknown error',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'No specials available at the moment.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildSpecialItem(SpecialModel special) {
    // Get associated product if any
    final product = special.productId != null ? _productsMap[special.productId] : null;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: product != null 
          ? () => Navigator.pushNamed(context, '/menu')
          : null,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.brown[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Icon(
                    Icons.local_offer,
                    color: Colors.amber[800],
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      special.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      special.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (product != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                          children: [
                            Icon(Icons.coffee, size: 12, color: Colors.brown[400]),
                            const SizedBox(width: 4),
                            Text(
                              product.name,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.brown[400],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(Icons.arrow_forward, size: 10, color: Colors.brown[400]),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: Text(
                  special.getDiscountDescription(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.red[700],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
