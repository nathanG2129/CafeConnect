import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class CoffeeGuidePage extends StatelessWidget {
  const CoffeeGuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E6D3),
      appBar: AppBar(
        title: const Text("Coffee Guide"),
        centerTitle: true,
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      drawer: const AppDrawer(),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            HeaderSection(),
            IntroSection(),
            CoffeeTypesSection(),
            BrewingTipsSection(),
          ],
        ),
      ),
    );
  }
}

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

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
            color: Colors.brown.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(Icons.coffee_maker, color: Colors.amber[300], size: 48),
          const SizedBox(height: 16),
          const Text(
            "Coffee Brewing Guide",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Discover the Art of Coffee",
            style: TextStyle(
              fontSize: 16,
              color: Colors.brown[100],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class IntroSection extends StatelessWidget {
  const IntroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
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
          Text(
            "Understanding Coffee",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.brown[700],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Coffee is more than just a beverage – it's an experience. From the selection of beans to the brewing method, each step contributes to creating the perfect cup. Let's explore different coffee types and brewing techniques.",
            style: TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Colors.brown[600],
            ),
          ),
        ],
      ),
    );
  }
}

class CoffeeTypesSection extends StatelessWidget {
  const CoffeeTypesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              "Popular Coffee Types",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.brown[700],
              ),
            ),
          ),
          _buildCoffeeTypeCard(
            "Espresso",
            "assets/coffees/expresso.jpg",
            "The foundation of many coffee drinks. Strong and concentrated.",
            "30ml shot",
          ),
          _buildCoffeeTypeCard(
            "Cappuccino",
            "assets/coffees/capuccino.jpg",
            "Equal parts espresso, steamed milk, and milk foam.",
            "150-180ml",
          ),
          _buildCoffeeTypeCard(
            "Latte",
            "assets/coffees/latte.jpg",
            "Espresso with steamed milk and a light layer of foam.",
            "240ml",
          ),
          _buildCoffeeTypeCard(
            "Americano",
            "assets/coffees/americano.jpg",
            "Espresso diluted with hot water.",
            "180ml",
          ),
          _buildCoffeeTypeCard(
            "Cold Brew",
            "assets/coffees/coldbrew.jpg",
            "Coffee steeped in cold water for 12-24 hours.",
            "200ml",
          ),
        ],
      ),
    );
  }

  Widget _buildCoffeeTypeCard(String name, String image, String description, String size) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.brown[50],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        size,
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
                  description,
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
    );
  }
}

class BrewingTipsSection extends StatelessWidget {
  const BrewingTipsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
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
        children: [
          Icon(Icons.tips_and_updates, color: Colors.amber[300], size: 32),
          const SizedBox(height: 16),
          const Text(
            "Pro Brewing Tips",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          _buildTip("Use freshly ground coffee beans"),
          _buildTip("Water temperature: 195°F to 205°F"),
          _buildTip("Clean equipment thoroughly"),
          _buildTip("Measure your coffee precisely"),
          _buildTip("Store beans in an airtight container"),
        ],
      ),
    );
  }

  Widget _buildTip(String tip) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.amber[300], size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              tip,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
