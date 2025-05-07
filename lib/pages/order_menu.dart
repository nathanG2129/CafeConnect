import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import 'package:flutter_activity1/models/cartModel.dart';
import 'package:flutter_activity1/models/orderModel.dart';
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
    return Scaffold(
      backgroundColor: const Color(0xFFF5E6D3),
      appBar: AppBar(
        title: const Text("Order Menu"),
        centerTitle: true,
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: _toggleCart,
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
        ],
      ),
      drawer: const AppDrawer(),
      body: _isCartOpen
          ? CartView(
              cart: _cart,
              onClose: _toggleCart,
              onUpdate: () => setState(() {}),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  const HeaderSection(),
                  MenuGridSection(
                    onAddToCart: (OrderModel order) {
                      setState(() {
                        _cart.addItem(order);
                      });
                    },
                  ),
                ],
              ),
            ),
    );
  }
}