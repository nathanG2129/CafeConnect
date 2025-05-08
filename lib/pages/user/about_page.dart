import 'package:flutter/material.dart';
import '../../widgets/app_drawer.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isLargeScreen = screenWidth >= 1100;
    final bool isMediumScreen = screenWidth >= 768 && screenWidth < 1100;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF5E6D3),
      appBar: AppBar(
        title: const Text("About Us"),
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left column - Story section
              Expanded(
                flex: 1,
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: const StorySection(),
                ),
              ),
              // Right column - Features and Contact
              Expanded(
                flex: 1,
                child: Container(
                  margin: const EdgeInsets.only(left: 12),
                  child: const Column(
                    children: [
                      FeaturesSection(),
                      SizedBox(height: 24),
                      ContactSection(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildTabletLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const HeaderSection(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left column - Story
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(right: 8, top: 16),
                  child: const StorySection(),
                ),
              ),
              // Right column - Features
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 8, top: 16),
                  child: const FeaturesSection(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const ContactSection(),
        ],
      ),
    );
  }
  
  Widget _buildMobileLayout() {
    return const SingleChildScrollView(
      child: Column(
        children: [
          HeaderSection(),
          StorySection(),
          FeaturesSection(),
          ContactSection(),
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
            Icons.coffee,
            size: 60,
            color: Colors.amber[300],
          ),
        ),
        const SizedBox(width: 24),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "CafeConnect",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Crafting Moments, One Cup at a Time",
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
            Icons.coffee,
            size: isSmallScreen ? 50 : 60,
            color: Colors.amber[300],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "CafeConnect",
          style: TextStyle(
            fontSize: isSmallScreen ? 28 : 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Crafting Moments, One Cup at a Time",
          style: TextStyle(
            fontSize: isSmallScreen ? 16 : 18,
            color: Colors.brown[100],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class StorySection extends StatelessWidget {
  const StorySection({super.key});

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
                child: Icon(Icons.history, color: Colors.brown[700], size: 28),
              ),
              const SizedBox(width: 12),
              Text(
                "Our Story",
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
            "Welcome to CafeConnect, where passion meets perfection. Since our founding, we've been dedicated to creating not just a coffee shop, but a community hub where people can connect, relax, and enjoy premium coffee in a warm, welcoming atmosphere.",
            style: TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Colors.brown[700],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Our journey began with a simple vision: to serve exceptional coffee while fostering meaningful connections. Every cup we serve represents our commitment to quality and community. From our carefully sourced beans to our thoughtfully designed spaces, we've created an experience that goes beyond the ordinary.",
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

class FeaturesSection extends StatelessWidget {
  const FeaturesSection({super.key});

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
                    color: isTabletOrLarger ? Colors.white : Colors.brown[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.star, color: Colors.brown[700], size: 28),
                ),
                const SizedBox(width: 12),
                Text(
                  "What Sets Us Apart",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown[800],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          _buildFeatureCard(
            Icons.coffee,
            "Premium Coffee Selection",
            "Carefully sourced beans and expert brewing methods",
          ),
          _buildFeatureCard(
            Icons.chair,
            "Cozy Atmosphere",
            "Thoughtfully designed spaces for work and relaxation",
          ),
          _buildFeatureCard(
            Icons.people,
            "Community Focus",
            "Regular events and a welcoming environment for all",
          ),
          _buildFeatureCard(
            Icons.phone_android,
            "Mobile Ordering",
            "Skip the line with our convenient mobile app",
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(IconData icon, String title, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.brown[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.brown[700], size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown[800],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
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

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isWideScreen = screenWidth >= 900;
    
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(screenWidth < 768 ? 16 : 0),
      padding: const EdgeInsets.all(24),
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
      child: isWideScreen
          ? _buildWideContactSection()
          : _buildCompactContactSection(),
    );
  }
  
  Widget _buildWideContactSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(Icons.contact_support, color: Colors.amber[300], size: 32),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Connect With Us",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "We'd love to hear from you! Reach out with any questions or feedback.",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.brown[100],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 20),
        ElevatedButton(
          onPressed: () {
            // Add contact functionality here
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber[300],
            foregroundColor: Colors.brown[900],
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            "Contact Us",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildCompactContactSection() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Icon(Icons.contact_support, color: Colors.amber[300], size: 32),
        ),
        const SizedBox(height: 16),
        const Text(
          "Connect With Us",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          "We'd love to hear from you!",
          style: TextStyle(
            fontSize: 16,
            color: Colors.brown[100],
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            // Add contact functionality here
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber[300],
            foregroundColor: Colors.brown[900],
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            "Contact Us",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
