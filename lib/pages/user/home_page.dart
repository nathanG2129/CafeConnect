import 'package:flutter/material.dart';
import '../../widgets/app_drawer.dart';
import '../../services/special_service.dart';
import '../../services/promotion_service.dart';
import '../../models/specialModel.dart';
import '../../models/promotionModel.dart';
import '../../models/productModel.dart';
import '../../widgets/special_product_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SpecialService _specialService = SpecialService();
  final PromotionService _promotionService = PromotionService();
  
  List<SpecialModel> _activeSpecials = [];
  List<PromotionModel> _activePromotions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final specials = await _specialService.getActiveSpecials();
      final promotions = await _promotionService.getActivePromotions();
      
      setState(() {
        _activeSpecials = specials;
        _activePromotions = promotions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.brown))
          : const SingleChildScrollView(
              child: Column(
                children: [
                  TitleSection(),
                  FeaturedDrinksSection(),
                  DynamicDailySpecialsSection(),
                  DynamicPromotionsSection(),
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

class DynamicDailySpecialsSection extends StatefulWidget {
  const DynamicDailySpecialsSection({super.key});

  @override
  State<DynamicDailySpecialsSection> createState() => _DynamicDailySpecialsSectionState();
}

class _DynamicDailySpecialsSectionState extends State<DynamicDailySpecialsSection> {
  final SpecialService _specialService = SpecialService();
  List<SpecialModel> _specials = [];
  Map<String, ProductModel> _relatedProducts = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSpecials();
  }

  Future<void> _loadSpecials() async {
    try {
      final specials = await _specialService.getActiveSpecials();
      
      // Load related products
      Map<String, ProductModel> relatedProducts = {};
      for (var special in specials) {
        if (special.relatedProductId != null && special.relatedProductId!.isNotEmpty) {
          final product = await _specialService.getRelatedProduct(special.relatedProductId);
          if (product != null) {
            relatedProducts[special.id] = product;
          }
        }
      }
      
      setState(() {
        _specials = specials;
        _relatedProducts = relatedProducts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
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
        child: const Center(
          child: CircularProgressIndicator(color: Colors.brown),
        ),
      );
    }

    if (_specials.isEmpty) {
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
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                'No specials available today',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
      );
    }

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
            ],
          ),
          const SizedBox(height: 16),
          ..._specials.map((special) => _buildSpecialItem(special)),
        ],
      ),
    );
  }

  Widget _buildSpecialItem(SpecialModel special) {
    final hasRelatedProduct = _relatedProducts.containsKey(special.id);
    final product = hasRelatedProduct ? _relatedProducts[special.id] : null;
    
    if (hasRelatedProduct && product != null) {
      // Use the reusable SpecialProductCard for specials with related products
      return SpecialProductCard(
        special: special,
        product: product,
        onAddToCart: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${special.name} added to cart'),
              backgroundColor: Colors.green,
            ),
          );
        },
        onViewDetails: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Viewing details for ${product.name}'),
              backgroundColor: Colors.blue,
            ),
          );
        },
      );
    } else {
      // Simple design for standalone specials
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.brown[300],
                borderRadius: BorderRadius.circular(2),
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
                  ),
                ],
              ),
            ),
            Text(
              '₱${special.price.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.brown[700],
              ),
            ),
          ],
        ),
      );
    }
  }
}

class DynamicPromotionsSection extends StatefulWidget {
  const DynamicPromotionsSection({super.key});

  @override
  State<DynamicPromotionsSection> createState() => _DynamicPromotionsSectionState();
}

class _DynamicPromotionsSectionState extends State<DynamicPromotionsSection> {
  final PromotionService _promotionService = PromotionService();
  List<PromotionModel> _promotions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPromotions();
  }

  Future<void> _loadPromotions() async {
    try {
      final promotions = await _promotionService.getActivePromotions();
      setState(() {
        _promotions = promotions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.brown[700],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.brown.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    if (_promotions.isEmpty) {
      return Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.brown[700],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.brown.withOpacity(0.2),
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
                Icon(Icons.campaign, color: Colors.amber[300]),
                const SizedBox(width: 8),
                const Text(
                  'Current Promotions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                'No promotions available right now',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.brown[100],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.brown[700],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.brown.withOpacity(0.2),
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
              Icon(Icons.campaign, color: Colors.amber[300]),
              const SizedBox(width: 8),
              const Text(
                'Current Promotions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._promotions.map((promotion) => _buildPromotionItem(
                promotion.title,
                promotion.time,
                promotion.description,
              )),
        ],
      ),
    );
  }

  Widget _buildPromotionItem(String title, String time, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.brown[600],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            time,
            style: TextStyle(
              fontSize: 14,
              color: Colors.brown[100],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.brown[100],
            ),
          ),
        ],
      ),
    );
  }
}
