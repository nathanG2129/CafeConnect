import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final AuthService _authService = AuthService();
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() {
    setState(() {
      _isLoggedIn = _authService.isUserLoggedIn();
    });
  }

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
              children: [
                _buildDrawerItem(
                  context,
                  icon: Icons.home,
                  title: 'Home',
                  onTap: () => Navigator.pushReplacementNamed(context, '/home'),
                ),
                if (_isLoggedIn)
                  _buildDrawerItem(
                    context,
                    icon: Icons.person,
                    title: 'Profile',
                    onTap: () => Navigator.pushReplacementNamed(context, '/profile'),
                  ),
                _buildDrawerItem(
                  context,
                  icon: Icons.coffee,
                  title: 'Order Menu',
                  onTap: () => Navigator.pushReplacementNamed(context, '/menu'),
                ),
                if (_isLoggedIn)
                  _buildDrawerItem(
                    context,
                    icon: Icons.receipt_long,
                    title: 'Order History',
                    onTap: () => Navigator.pushReplacementNamed(context, '/order-history'),
                  ),
                _buildDrawerItem(
                  context,
                  icon: Icons.menu_book,
                  title: 'Coffee Guide',
                  onTap: () => Navigator.pushReplacementNamed(context, '/guide'),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.info,
                  title: 'About Us',
                  onTap: () => Navigator.pushReplacementNamed(context, '/about'),
                ),
                const Divider(height: 1),
                if (_isLoggedIn)
                  _buildDrawerItem(
                    context,
                    icon: Icons.logout,
                    title: 'Sign Out',
                    onTap: () async {
                      await _authService.signOut();
                      setState(() {
                        _isLoggedIn = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('You have been signed out'),
                          backgroundColor: Colors.brown,
                        ),
                      );
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                  )
                else
                  _buildDrawerItem(
                    context,
                    icon: Icons.login,
                    title: 'Sign In',
                    onTap: () => Navigator.pushReplacementNamed(context, '/login'),
                  ),
              ],
            ),
          ),
          const DrawerFooterWidget(),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.brown),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.brown,
        ),
      ),
      onTap: onTap,
    );
  }
}

class DrawerHeaderWidget extends StatelessWidget {
  const DrawerHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService _authService = AuthService();
    final bool isLoggedIn = _authService.isUserLoggedIn();
    
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
            'Cafe Connect',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Your Coffee Destination',
            style: TextStyle(
              color: Colors.brown[100],
              fontSize: 14,
            ),
          ),
          if (isLoggedIn) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Colors.brown[600],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'Logged In',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
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