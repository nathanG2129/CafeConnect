import 'package:flutter/material.dart';
import 'package:flutter_activity1/models/orderModel.dart';
import 'package:flutter_activity1/widgets/order_menu/order_dialog.dart';

class MenuGridSection extends StatelessWidget {
  final Function(OrderModel) onAddToCart;

  const MenuGridSection({
    super.key,
    required this.onAddToCart,
  });

  final List<Map<String, dynamic>> coffees = const [
    {
      'name': 'Espresso',
      'image': 'assets/coffees/expresso.jpg',
      'price': 2.99,
      'description': 'Strong and concentrated coffee shot',
    },
    {
      'name': 'Cappuccino',
      'image': 'assets/coffees/capuccino.jpg',
      'price': 4.49,
      'description': 'Equal parts espresso, steamed milk, and milk foam',
    },
    {
      'name': 'Latte',
      'image': 'assets/coffees/latte.jpg',
      'price': 4.29,
      'description': 'Espresso with steamed milk and light foam',
    },
    {
      'name': 'Americano',
      'image': 'assets/coffees/americano.jpg',
      'price': 3.49,
      'description': 'Espresso diluted with hot water',
    },
    {
      'name': 'Mocha',
      'image': 'assets/coffees/mocha.jpg',
      'price': 4.49,
      'description': 'Espresso with chocolate and steamed milk',
    },
    {
      'name': 'Cold Brew',
      'image': 'assets/coffees/coldbrew.jpg',
      'price': 3.99,
      'description': 'Smooth, cold-steeped coffee',
    },
    {
      'name': 'Caramel Macchiato',
      'image': 'assets/coffees/macchiato.jpg',
      'price': 4.99,
      'description': 'Vanilla-flavored drink marked with espresso and caramel',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: coffees.length,
        itemBuilder: (context, index) {
          final coffee = coffees[index];
          return _buildCoffeeCard(context, coffee);
        },
      ),
    );
  }

  Widget _buildCoffeeCard(BuildContext context, Map<String, dynamic> coffee) {
    return GestureDetector(
      onTap: () => _showOrderDialog(context, coffee),
      child: Container(
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
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.asset(
                  coffee['image'],
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    coffee['name'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${coffee['price'].toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOrderDialog(BuildContext context, Map<String, dynamic> coffee) {
    showDialog(
      context: context,
      builder: (context) => OrderDialog(
        coffee: coffee,
        onAddToCart: onAddToCart,
      ),
    );
  }
} 