import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/userModel.dart';

class AppDrawer extends StatefulWidget {
  final String? currentRoute;
  
  const AppDrawer({super.key, this.currentRoute});

  /// Static method to preload drawer data in advance
  static Future<void> preloadDrawerData() async {
    await AppDrawerState.preloadData();
    return;
  }

  @override
  State<AppDrawer> createState() => AppDrawerState();
}

class AppDrawerState extends State<AppDrawer> {
  static final AuthService _authService = AuthService();
  
  // Static cache for drawer data
  static Map<String, dynamic>? _cachedDrawerData;
  static Future<Map<String, dynamic>>? _loadingFuture;
  
  late Future<Map<String, dynamic>> _drawerDataFuture;
  
  /// Static method to preload data that can be called from anywhere
  static Future<Map<String, dynamic>> preloadData() async {
    // If we're already loading, return that future
    if (_loadingFuture != null) {
      return _loadingFuture!;
    }
    
    // Start loading and cache the future
    _loadingFuture = _fetchDrawerData();
    
    try {
      // Cache the result when done
      _cachedDrawerData = await _loadingFuture!;
      return _cachedDrawerData!;
    } finally {
      // Clear the loading future when done (success or error)
      _loadingFuture = null;
    }
  }
  
  /// Static method to clear cached data (e.g., after logout)
  static void clearCache() {
    _cachedDrawerData = null;
  }
  
  /// Actual data fetching logic
  static Future<Map<String, dynamic>> _fetchDrawerData() async {
    final isLoggedIn = _authService.isUserLoggedIn();
    UserModel? currentUser;
    bool isStaff = false;
    
    if (isLoggedIn) {
      currentUser = await _authService.getCurrentUserData();
      isStaff = currentUser?.role == 'staff';
    }
    
    return {
      'isLoggedIn': isLoggedIn,
      'isStaff': isStaff,
      'currentUser': currentUser,
    };
  }
  
  @override
  void initState() {
    super.initState();
    // Use cached data if available, otherwise load it
    _drawerDataFuture = _cachedDrawerData != null 
        ? Future.value(_cachedDrawerData)
        : preloadData();
  }

  @override
  Widget build(BuildContext context) {
    // Determine which page is currently active based on route
    final String currentRoute = widget.currentRoute ?? ModalRoute.of(context)?.settings.name ?? '/home';
    
    return FutureBuilder<Map<String, dynamic>>(
      future: _drawerDataFuture,
      builder: (context, snapshot) {
        // During first load, show a drawer with minimal animation
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Instead of a loading spinner, show a simplified drawer
          // This makes the transition less jarring
          return _buildSimplifiedDrawer(context);
        }
        
        // If there's an error, show a simple drawer with minimal options
        if (snapshot.hasError) {
          return _buildErrorDrawer(context);
        }
        
        // Extract data from snapshot
        final data = snapshot.data!;
        final bool isLoggedIn = data['isLoggedIn'];
        final bool isStaff = data['isStaff'];
        final UserModel? currentUser = data['currentUser'];
        
        // Update the cache if needed
        if (_cachedDrawerData != data) {
          _cachedDrawerData = data;
        }
        
        // Build the full drawer with the loaded data
        return _buildFullDrawer(context, currentRoute, isLoggedIn, isStaff, currentUser);
      },
    );
  }

  Widget _buildSimplifiedDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFF5E6D3),
      child: Column(
        children: [
          Container(
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
                  child: Icon(
                    Icons.coffee,
                    size: 32,
                    color: Colors.brown[700],
                  ),
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
              ],
            ),
          ),
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
                // Just show a few basic items
                _buildCategorySeparator("FEATURES"),
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
              ],
            ),
          ),
          const DrawerFooterWidget(),
        ],
      ),
    );
  }

  Widget _buildErrorDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFF5E6D3),
      child: Column(
        children: [
          const DrawerHeaderWidget(currentUser: null),
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
                _buildDrawerItem(
                  context,
                  icon: Icons.refresh,
                  customIcon: '🔄',
                  title: 'Retry Connection',
                  index: -1,
                  route: '',
                  onTap: () {
                    setState(() {
                      // Clear cache and try again
                      clearCache();
                      _drawerDataFuture = preloadData();
                    });
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

  Widget _buildFullDrawer(
    BuildContext context, 
    String currentRoute, 
    bool isLoggedIn, 
    bool isStaff, 
    UserModel? currentUser
  ) {
    return Drawer(
      backgroundColor: const Color(0xFFF5E6D3),
      child: Column(
        children: [
          DrawerHeaderWidget(currentUser: currentUser),
          const SizedBox(height: 12),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // HOME SECTION
                if (isStaff) 
                  _buildDrawerItem(
                    context,
                    icon: Icons.dashboard_outlined,
                    customIcon: '📊',
                    title: 'Staff Dashboard',
                    index: 0,
                    route: '/staff-dashboard',
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/staff-dashboard');
                    },
                  )
                else
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
                
                if (isLoggedIn)
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
                
                // MAIN FEATURES
                _buildCategorySeparator(isStaff ? "MANAGEMENT" : "FEATURES"),
                
                if (isStaff) ...[
                  _buildDrawerItem(
                    context,
                    icon: Icons.coffee,
                    customIcon: '☕',
                    title: 'Manage Products',
                    index: 2,
                    route: '/manage-products',
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/manage-products');
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.receipt_long,
                    customIcon: '📋',
                    title: 'Manage Orders',
                    index: 3,
                    route: '/manage-orders',
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/manage-orders');
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.price_change,
                    customIcon: '💰',
                    title: 'Update Menu Pricing',
                    index: 7,
                    route: '/update-pricing',
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/update-pricing');
                    },
                  ),
                ] else ...[
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
                  if (isLoggedIn)
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
                  
                  // EXPLORE SECTION
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
                ],
                
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
                
                // ACCOUNT SECTION
                _buildCategorySeparator("ACCOUNT"),
                
                if (isLoggedIn)
                  _buildDrawerItem(
                    context,
                    icon: Icons.logout_outlined,
                    customIcon: '🚪',
                    title: 'Sign Out',
                    index: 6,
                    route: '',
                    onTap: () async {
                      await _authService.signOut();
                      
                      
                      // Clear cache and reload data
                      clearCache();
                      setState(() {
                        _drawerDataFuture = preloadData();
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

  // Method to get the selected index based on the current route
  int _getSelectedIndex(String currentRoute) {
    switch (currentRoute) {
      case '/home':
      case '/staff-dashboard':
        return 0;
      case '/profile':
        return 1;
      case '/menu':
      case '/manage-products':
        return 2;
      case '/order-history':
      case '/manage-orders':
        return 3;
      case '/guide':
        return 4;
      case '/about':
        return 5;
      case '/login':
      case '/register':
        return 6;
      default:
        return 0;
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
    final bool isSelected = currentRoute == route || index == _getSelectedIndex(currentRoute);
    
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
  final UserModel? currentUser;
  
  const DrawerHeaderWidget({super.key, this.currentUser});

  @override
  Widget build(BuildContext context) {
    final bool isLoggedIn = currentUser != null;
    final bool isStaff = currentUser?.role == 'staff';
    
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
            isStaff ? Colors.brown.shade900 : Colors.brown.shade900,
            isStaff ? Colors.brown.shade800 : Colors.brown.shade700,
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
            child: Icon(
              isStaff ? Icons.badge : Icons.coffee,
              size: 32,
              color: Colors.brown[700],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            isLoggedIn ? (currentUser?.name ?? 'Cafe Connect') : 'Cafe Connect',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            isStaff ? 'Staff Portal' : 'Your Coffee Destination',
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
                color: isStaff ? Colors.amber[700] : Colors.brown[600],
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                isStaff ? 'Staff Account' : 'Customer',
                style: const TextStyle(
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