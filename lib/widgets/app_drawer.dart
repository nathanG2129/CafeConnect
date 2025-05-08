import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AppDrawer extends StatefulWidget {
  final String? currentRoute;
  
  const AppDrawer({super.key, this.currentRoute});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final AuthService _authService = AuthService();
  bool _isLoggedIn = false;
  int _selectedIndex = 0;

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
    // Determine which page is currently active based on route
    final String currentRoute = widget.currentRoute ?? ModalRoute.of(context)?.settings.name ?? '/home';
    _updateSelectedIndex(currentRoute);

    return Drawer(
      backgroundColor: const Color(0xFFF5E6D3),
      child: Column(
        children: [
          const DrawerHeaderWidget(),
          const SizedBox(height: 12),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  context,
                  icon: Icons.home_outlined,
                  customIcon: '☕',
                  title: 'Home',
                  index: 0,
                  route: '/home',
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                ),
                if (_isLoggedIn)
                  _buildDrawerItem(
                    context,
                    icon: Icons.person_outline,
                    customIcon: '👤',
                    title: 'Profile',
                    index: 1,
                    route: '/profile',
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/profile');
                    },
                  ),
                _buildDrawerItem(
                  context,
                  icon: Icons.restaurant_menu,
                  customIcon: '🥐',
                  title: 'Order Menu',
                  index: 2,
                  route: '/menu',
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/menu');
                  },
                ),
                if (_isLoggedIn)
                  _buildDrawerItem(
                    context,
                    icon: Icons.receipt_long,
                    customIcon: '📋',
                    title: 'Order History',
                    index: 3,
                    route: '/order-history',
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/order-history');
                    },
                  ),
                
                // Visual category separator
                _buildCategorySeparator("EXPLORE"),
                
                _buildDrawerItem(
                  context,
                  icon: Icons.menu_book_outlined,
                  customIcon: '📘',
                  title: 'Coffee Guide',
                  index: 4,
                  route: '/guide',
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/guide');
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.info_outline,
                  customIcon: '📍',
                  title: 'About Us',
                  index: 5,
                  route: '/about',
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/about');
                  },
                ),
                
                // Visual category separator
                _buildCategorySeparator("ACCOUNT"),
                
                if (_isLoggedIn)
                  _buildDrawerItem(
                    context,
                    icon: Icons.logout_outlined,
                    customIcon: '🚪',
                    title: 'Sign Out',
                    index: 6,
                    route: '',
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
                    icon: Icons.login_outlined,
                    customIcon: '🔑',
                    title: 'Sign In',
                    index: 6,
                    route: '/login',
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                  ),
              ],
            ),
          ),
          const DrawerFooterWidget(),
        ],
      ),
    );
  }

  // Method to update the selected index based on the current route
  void _updateSelectedIndex(String currentRoute) {
    switch (currentRoute) {
      case '/home':
        _selectedIndex = 0;
        break;
      case '/profile':
        _selectedIndex = 1;
        break;
      case '/menu':
        _selectedIndex = 2;
        break;
      case '/order-history':
        _selectedIndex = 3;
        break;
      case '/guide':
        _selectedIndex = 4;
        break;
      case '/about':
        _selectedIndex = 5;
        break;
      case '/login':
      case '/register':
        _selectedIndex = 6;
        break;
      default:
        _selectedIndex = 0;
    }
  }

  Widget _buildCategorySeparator(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.brown[600],
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.brown.withOpacity(0.3),
                    Colors.brown.withOpacity(0.1),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String customIcon,
    required String title,
    required int index,
    required String route,
    required VoidCallback onTap,
  }) {
    // Check if this is the current route
    final String currentRoute = ModalRoute.of(context)?.settings.name ?? '/home';
    
    // Check if this item should be selected based on route or index
    final bool isSelected = currentRoute == route || index == _selectedIndex;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? Colors.brown.withOpacity(0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.brown.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.brown.withOpacity(0.1),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Text(
            customIcon,
            style: TextStyle(
              fontSize: 20,
              color: Colors.brown[800],
            ),
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.brown[800],
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

class DrawerHeaderWidget extends StatelessWidget {
  const DrawerHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();
    final bool isLoggedIn = authService.isUserLoggedIn();
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 24,
        bottom: 24,
        left: 24,
        right: 24,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.brown.shade900,
            Colors.brown.shade700,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
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
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Text(
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
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        '© 2025 CafeConnect',
        style: TextStyle(
          color: Colors.brown[400],
          fontSize: 12,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
} 