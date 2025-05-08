import 'package:flutter/material.dart';
import 'dart:math' as math;
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
        elevation: 2,
      ),
      drawer: const AppDrawer(),
      body: const ResponsiveHomeLayout(),
    );
  }
}

class ResponsiveHomeLayout extends StatelessWidget {
  const ResponsiveHomeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the screen width to determine layout
    final screenWidth = MediaQuery.of(context).size.width;
    
    // For larger screens (tablets and desktops)
    if (screenWidth >= 900) {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const TitleSection(),
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        const FeaturedDrinksSection(),
                        const SizedBox(height: 24),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.brown[50],
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.brown.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome to CafeConnect',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.brown[800],
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Enjoy our carefully selected coffee beans, sourced from the finest regions around the world. Our baristas are ready to make your perfect cup!',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.brown[600],
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  const Expanded(
                    flex: 2,
                    child: DailySpecialsSection(),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
    // For medium screens (larger tablets)
    else if (screenWidth >= 600) {
      return const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TitleSection(),
            SizedBox(height: 20),
            FeaturedDrinksSection(),
            SizedBox(height: 20),
            DailySpecialsSection(),
          ],
        ),
      );
    }
    // For smaller screens (phones)
    else {
      return const SingleChildScrollView(
        child: Column(
          children: [
            TitleSection(),
            FeaturedDrinksSection(),
            DailySpecialsSection(),
          ],
        ),
      );
    }
  }
}

class TitleSection extends StatelessWidget {
  const TitleSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isSmallScreen = screenWidth < 600;
    
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(isSmallScreen ? 16 : 0),
      padding: EdgeInsets.all(isSmallScreen ? 24 : 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.brown[800]!,
            Colors.brown[600]!,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(
                  Icons.coffee,
                  color: Colors.amber[300],
                  size: isSmallScreen ? 40 : 48,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CafeConnect',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isSmallScreen ? 32 : 38,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Your Perfect Coffee Destination',
                    style: TextStyle(
                      color: Colors.brown[100],
                      fontSize: isSmallScreen ? 16 : 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
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
      'description': 'Sweet caramel with espresso and milk',
    },
    {
      'name': 'Mocha',
      'image': 'assets/coffees/mocha.jpg',
      'price': '₱4.49',
      'description': 'Rich chocolate and coffee blend',
    },
    {
      'name': 'Cold Brew',
      'image': 'assets/coffees/coldbrew.jpg',
      'price': '₱3.99',
      'description': 'Smooth, slow-brewed cold coffee',
    },
    {
      'name': 'Americano',
      'image': 'assets/coffees/americano.jpg',
      'price': '₱3.49',
      'description': 'Espresso diluted with hot water',
    },
    {
      'name': 'Latte',
      'image': 'assets/coffees/latte.jpg',
      'price': '₱4.29',
      'description': 'Espresso with steamed milk',
    },
    {
      'name': 'Cappuccino',
      'image': 'assets/coffees/capuccino.jpg',
      'price': '₱4.49',
      'description': 'Equal parts espresso, milk, and foam',
    },
    {
      'name': 'Espresso',
      'image': 'assets/coffees/expresso.jpg',
      'price': '₱2.99',
      'description': 'Concentrated coffee shot',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final isMediumScreen = screenWidth >= 600 && screenWidth < 900;
    
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 0 : 16),
      decoration: isSmallScreen 
          ? null 
          : BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.brown.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 16 : 8,
              vertical: 12,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.local_cafe, color: Colors.brown[700], size: isSmallScreen ? 20 : 24),
                    const SizedBox(width: 8),
                    Text(
                      'Featured Drinks',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 20 : 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown[800],
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/menu');
                  },
                  child: Row(
                    children: [
                      Text(
                        'View All',
                        style: TextStyle(
                          color: Colors.brown[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, size: 14, color: Colors.brown[700]),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          
          // Grid view for medium and large screens
          if (!isSmallScreen)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isMediumScreen ? 2 : 3,
                childAspectRatio: isMediumScreen ? 0.85 : 0.9,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: isMediumScreen ? math.min(4, featuredDrinks.length) : 6,
              itemBuilder: (context, index) {
                final drink = featuredDrinks[index];
                return _buildFeaturedDrinkCard(
                  drink['name'],
                  drink['image'],
                  drink['price'],
                  drink['description'],
                  isGridView: true,
                );
              },
            )
          
          // Horizontal scrolling list for small screens
          else
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
                    drink['description'],
                    isGridView: false,
                  );
                },
              ),
            ),
          
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildFeaturedDrinkCard(
    String name,
    String image,
    String price,
    String description, {
    required bool isGridView,
  }) {
    return Container(
      width: isGridView ? null : 160,
      margin: isGridView ? null : const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.brown.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.asset(
                  image,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.brown[800]!.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      price,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  if (isGridView) 
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    
    return Container(
      margin: EdgeInsets.all(isSmallScreen ? 16 : 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Colors.brown[50]!,
          ],
        ),
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
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.brown[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.brown.withOpacity(0.1)),
                ),
                child: Icon(Icons.local_offer, color: Colors.brown[700], size: isSmallScreen ? 20 : 24),
              ),
              const SizedBox(width: 12),
              Text(
                'Today\'s Specials',
                style: TextStyle(
                  fontSize: isSmallScreen ? 20 : 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown[800],
                ),
              ),
              const Spacer(),
              if (!_isLoading) 
                IconButton(
                  icon: Icon(Icons.refresh, size: 20, color: Colors.brown[700]),
                  onPressed: _loadSpecials,
                  tooltip: 'Refresh specials',
                ),
            ],
          ),
          const SizedBox(height: 16),
          // Help text explaining that specials are automatically applied
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.amber[700], size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Specials are automatically applied when ordering!',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.amber[900],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _isLoading
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        CircularProgressIndicator(color: Colors.brown[400]),
                        const SizedBox(height: 16),
                        Text(
                          'Loading today\'s specials...',
                          style: TextStyle(
                            color: Colors.brown[400],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
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
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.error_outline, color: Colors.orange, size: 40),
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage ?? 'Unknown error',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: _loadSpecials,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.brown[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.brown[100]!.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.coffee_outlined, color: Colors.brown[300], size: 40),
            ),
            const SizedBox(height: 16),
            Text(
              'No specials available at the moment.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.brown[300],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Check back later for new deals!',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecialItem(SpecialModel special) {
    // Get associated product if any
    final product = special.productId != null ? _productsMap[special.productId] : null;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shadowColor: Colors.brown.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: product != null 
          ? () => Navigator.pushNamed(context, '/menu')
          : null,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.amber.withOpacity(0.3)),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.local_offer,
                        color: Colors.amber[800],
                        size: 30,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                special.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.red.withOpacity(0.3)),
                              ),
                              child: Text(
                                special.getDiscountDescription(),
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red[700],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          special.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (product != null)
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.brown[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.coffee, size: 14, color: Colors.brown[400]),
                      const SizedBox(width: 6),
                      Text(
                        product.name,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.brown[700],
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.arrow_forward, size: 12, color: Colors.brown[400]),
                      const SizedBox(width: 2),
                      Text(
                        'View in Menu',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.brown[700],
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
  }
}
