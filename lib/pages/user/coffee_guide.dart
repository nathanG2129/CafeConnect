import 'package:flutter/material.dart';
import '../../widgets/app_drawer.dart';

class CoffeeGuidePage extends StatelessWidget {
  const CoffeeGuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isLargeScreen = screenWidth >= 1100;
    final bool isMediumScreen = screenWidth >= 768 && screenWidth < 1100;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF5E6D3),
      appBar: AppBar(
        title: const Text("Coffee Guide"),
        centerTitle: true,
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      drawer: const AppDrawer(),
      body: isLargeScreen
          ? _buildDesktopLayout()
          : isMediumScreen
              ? _buildTabletLayout()
              : _buildMobileLayout(),
    );
  }
  
  Widget _buildDesktopLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const HeaderSection(),
          const SizedBox(height: 24),
          const IntroSection(),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Coffee types on the left
              const Expanded(
                flex: 2,
                child: CoffeeTypesSection(),
              ),
              const SizedBox(width: 24),
              // Tips on the right
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.brown.withOpacity(0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
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
                                ),
                                child: Icon(Icons.coffee_maker, color: Colors.brown[700], size: 24),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                "Coffee Basics",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.brown[800],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildBasicInfoItem("Arabica", "Smooth, subtle flavors, higher quality"),
                          _buildBasicInfoItem("Robusta", "Stronger, harsher taste, more caffeine"),
                          _buildBasicInfoItem("Light Roast", "Higher acidity, more original flavor"),
                          _buildBasicInfoItem("Dark Roast", "Bolder, smoky/sweet flavors"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const BrewingTipsSection(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildTabletLayout() {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          HeaderSection(),
          SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Intro on the left
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: IntroSection(),
                ),
              ),
              // Tips on the right
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: BrewingTipsSection(),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          CoffeeTypesSection(),
        ],
      ),
    );
  }
  
  Widget _buildMobileLayout() {
    return const SingleChildScrollView(
      child: Column(
        children: [
          HeaderSection(),
          IntroSection(),
          CoffeeTypesSection(),
          BrewingTipsSection(),
        ],
      ),
    );
  }
  
  Widget _buildBasicInfoItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.circle, size: 10, color: Colors.brown[400]),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.brown[700],
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.brown[600],
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

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

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
      child: screenWidth >= 768
          ? _buildWideHeader()
          : _buildCompactHeader(isSmallScreen),
    );
  }
  
  Widget _buildWideHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.coffee_maker,
            size: 48,
            color: Colors.amber[300],
          ),
        ),
        const SizedBox(width: 24),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Coffee Brewing Guide",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Discover the Art of Coffee",
              style: TextStyle(
                fontSize: 20,
                color: Colors.brown[100],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildCompactHeader(bool isSmallScreen) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.coffee_maker,
            size: isSmallScreen ? 40 : 48,
            color: Colors.amber[300],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "Coffee Brewing Guide",
          style: TextStyle(
            fontSize: isSmallScreen ? 24 : 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Discover the Art of Coffee",
          style: TextStyle(
            fontSize: isSmallScreen ? 14 : 16,
            color: Colors.brown[100],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class IntroSection extends StatelessWidget {
  const IntroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: screenWidth < 768 ? 16 : 0, 
        vertical: screenWidth < 768 ? 8 : 0,
      ),
      padding: const EdgeInsets.all(20),
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
                ),
                child: Icon(Icons.menu_book, color: Colors.brown[700], size: 24),
              ),
              const SizedBox(width: 12),
              Text(
                "Understanding Coffee",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            "Coffee is more than just a beverage – it's an experience. From the selection of beans to the brewing method, each step contributes to creating the perfect cup. Let's explore different coffee types and brewing techniques.",
            style: TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Colors.brown[700],
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
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isTabletOrLarger = screenWidth >= 768;
    
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isTabletOrLarger ? 0 : 16,
        vertical: isTabletOrLarger ? 0 : 8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.brown.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(Icons.coffee, color: Colors.brown[700], size: 24),
                ),
                const SizedBox(width: 12),
                Text(
                  "Popular Coffee Types",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown[800],
                  ),
                ),
              ],
            ),
          ),
          // Responsive grid layout for coffee types
          if (screenWidth >= 900)
            _buildCoffeeTypesGrid()
          else
            Column(
              children: [
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
        ],
      ),
    );
  }

  Widget _buildCoffeeTypesGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 0.8,
      children: [
        _buildCoffeeTypeGridCard(
          "Espresso",
          "assets/coffees/expresso.jpg",
          "The foundation of many coffee drinks. Strong and concentrated.",
          "30ml shot",
        ),
        _buildCoffeeTypeGridCard(
          "Cappuccino",
          "assets/coffees/capuccino.jpg",
          "Equal parts espresso, steamed milk, and milk foam.",
          "150-180ml",
        ),
        _buildCoffeeTypeGridCard(
          "Latte",
          "assets/coffees/latte.jpg",
          "Espresso with steamed milk and a light layer of foam.",
          "240ml",
        ),
        _buildCoffeeTypeGridCard(
          "Americano",
          "assets/coffees/americano.jpg",
          "Espresso diluted with hot water.",
          "180ml",
        ),
        _buildCoffeeTypeGridCard(
          "Cold Brew",
          "assets/coffees/coldbrew.jpg",
          "Coffee steeped in cold water for 12-24 hours.",
          "200ml",
        ),
        _buildCoffeeTypeGridCard(
          "Mocha",
          "assets/coffees/mocha.jpg",
          "Espresso with chocolate and steamed milk.",
          "240ml",
        ),
      ],
    );
  }

  Widget _buildCoffeeTypeCard(String name, String image, String description, String size) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.asset(
              image,
              height: 180,
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
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown[800],
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
  
  Widget _buildCoffeeTypeGridCard(String name, String image, String description, String size) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.asset(
              image,
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown[800],
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.brown[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          size,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.brown[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.brown[600],
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
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
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(screenWidth < 768 ? 16 : 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.brown[700]!,
            Colors.brown[600]!,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
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
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(Icons.tips_and_updates, color: Colors.amber[300], size: 32),
          ),
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
          _buildTip("Use filtered water for best taste"),
          _buildTip("Pre-warm your cup for optimal temperature"),
        ],
      ),
    );
  }

  Widget _buildTip(String tip) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.amber[300]!.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check_circle, color: Colors.amber[300], size: 18),
          ),
          const SizedBox(width: 12),
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
