import 'package:flutter/material.dart';
import '../pages/registration_page.dart';
import '../pages/order_menu.dart';
import '../pages/coffee_guide.dart';
import '../pages/about_page.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: const Color(0xFFF5E6D3),
        child: ListView(
          padding: EdgeInsets.zero,
          children: const [
            DrawerHeaderWidget(),
            DrawerListView(),
          ],
        ),
      ),
    );
  }
}

class DrawerHeaderWidget extends StatelessWidget {
  const DrawerHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.brown,
      ),
      height: 200,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: Icon(Icons.coffee, size: 35, color: Colors.brown),
          ),
          SizedBox(height: 10),
          Text(
            'CafeConnect Menu',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
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
        ListTile(
          leading: const Icon(Icons.home, color: Colors.brown),
          title: const Text('Home'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.app_registration, color: Colors.brown),
          title: const Text('Membership'),
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