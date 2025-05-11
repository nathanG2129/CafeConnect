import 'package:flutter/material.dart';
import '../../widgets/app_drawer.dart';
import 'package:flutter_activity1/models/cartModel.dart';
import 'package:flutter_activity1/models/orderItemModel.dart';
import 'package:flutter_activity1/widgets/order_menu/header_section.dart';
import 'package:flutter_activity1/widgets/order_menu/menu_grid_section.dart';
import 'package:flutter_activity1/widgets/order_menu/cart_view.dart';

class OrderMenuPage extends StatefulWidget {
  const OrderMenuPage({super.key});

  @override
  State<OrderMenuPage> createState() => _OrderMenuPageState();
}

class _OrderMenuPageState extends State<OrderMenuPage> {
  final CartModel _cart = CartModel();
  bool _isCartOpen = false;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Check if we should open the cart automatically (from order history reorder)
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && args['openCart'] == true) {
      setState(() {
        _isCartOpen = true;
      });
    }
  }

  void _loadCart() {
    _cart.loadFromStorage();
    setState(() {});
  }

  void _toggleCart() {
    setState(() {
      _isCartOpen = !_isCartOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth >= 1100;
    final bool isTablet = screenWidth >= 768 && screenWidth < 1100;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF5E6D3),
      appBar: AppBar(
        title: const Text("Order Menu"),
        centerTitle: true,
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: _toggleCart,
                tooltip: 'View Cart',
              ),
              if (_cart.itemCount > 0)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      _cart.itemCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: const AppDrawer(),
      body: isDesktop
          ? _buildDesktopLayout()
          : isTablet
              ? _buildTabletLayout()
              : _buildMobileLayout(),
    );
  }
  
  Widget _buildDesktopLayout() {
    return Row(
      children: [
        // Menu section (2/3 of screen)
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const HeaderSection(),
                  MenuGridSection(
                    onAddToCart: (OrderItemModel orderItem) {
                      setState(() {
                        _cart.addItem(orderItem);
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        // Cart section (1/3 of screen)
        Expanded(
          flex: 1,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.brown.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(-2, 0),
                ),
              ],
            ),
            child: CartView(
              cart: _cart,
              onClose: () {}, // No-op since cart is always visible on desktop
              onUpdate: () => setState(() {}),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildTabletLayout() {
    if (_isCartOpen) {
      return CartView(
        cart: _cart,
        onClose: _toggleCart,
        onUpdate: () => setState(() {}),
      );
    }
    
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          const SliverPadding(
            padding: EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(
              child: HeaderSection(),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: MenuGridSection(
                onAddToCart: (OrderItemModel orderItem) {
                  setState(() {
                    _cart.addItem(orderItem);
                    
                    // Automatically show cart when adding first item (optional)
                    if (_cart.itemCount == 1) {
                      _isCartOpen = true;
                    }
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildMobileLayout() {
    if (_isCartOpen) {
      return CartView(
        cart: _cart,
        onClose: _toggleCart,
        onUpdate: () => setState(() {}),
      );
    }
    
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: HeaderSection(),
          ),
          SliverToBoxAdapter(
            child: MenuGridSection(
              onAddToCart: (OrderItemModel orderItem) {
                setState(() {
                  _cart.addItem(orderItem);
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}