import 'package:flutter/material.dart';
import '../pages/home_page.dart';
import '../pages/registration_page.dart';
import '../pages/order_menu.dart';
import '../pages/coffee_guide.dart';
import '../pages/about_page.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFF5E6D3),
      child: Column(
        children: [
          const DrawerHeaderWidget(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: const [
                DrawerListView(),
              ],
            ),
          ),
          const DrawerFooterWidget(),
        ],
      ),
    );
  }
}

class DrawerHeaderWidget extends StatelessWidget {
  const DrawerHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 24,
        bottom: 24,
        left: 24,
        right: 24,
      ),
      decoration: BoxDecoration(
        color: Colors.brown[700],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(Icons.coffee, size: 32, color: Colors.brown[700]),
          ),
          const SizedBox(height: 16),
          const Text(
            'CafeConnect',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Your Perfect Coffee Destination',
            style: TextStyle(
              color: Colors.brown[100],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class DrawerListView extends StatelessWidget {
  const DrawerListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        ListTile(
          leading: const Icon(Icons.home, color: Colors.brown),
          title: const Text('Home'),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.coffee, color: Colors.brown),
          title: const Text('Order Menu'),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const OrderMenuPage(),
              ),
            );
          },
        ),
        const Divider(height: 1),
        ListTile(
          leading: const Icon(Icons.app_registration, color: Colors.brown),
          title: const Text('Join Membership'),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.brown[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'FREE',
              style: TextStyle(
                color: Colors.brown[700],
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RegistrationPage(),
              ),
            );
          },
        ),
        const Divider(height: 1),
        ListTile(
          leading: const Icon(Icons.menu_book, color: Colors.brown),
          title: const Text('Coffee Guide'),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CoffeeGuidePage(),
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.info, color: Colors.brown),
          title: const Text('About'),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AboutPage(),
              ),
            );
          },
        ),
      ],
    );
  }
}

class DrawerFooterWidget extends StatelessWidget {
  const DrawerFooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialButton(Icons.facebook, () {}),
              const SizedBox(width: 24),
              _buildSocialButton(Icons.camera_alt, () {}),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '© 2025 CafeConnect',
            style: TextStyle(
              color: Colors.brown[400],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.brown[50],
          borderRadius: BorderRadius.circular(30),
        ),
        child: Icon(
          icon,
          color: Colors.brown[700],
          size: 24,
        ),
      ),
    );
  }
} 