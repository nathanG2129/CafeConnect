import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class OrderMenuPage extends StatelessWidget {
  const OrderMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E6D3),
      appBar: AppBar(
        title: const Text("Order Menu"),
        centerTitle: true,
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      drawer: const AppDrawer(),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            HeaderSection(),
            MenuGridSection(),
          ],
        ),
      ),
    );
  }
}

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.brown[700],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.brown.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(Icons.coffee_maker, color: Colors.amber[300], size: 48),
          const SizedBox(height: 16),
          const Text(
            "Place Your Order",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Tap on a coffee to customize your order",
            style: TextStyle(
              fontSize: 16,
              color: Colors.brown[100],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class MenuGridSection extends StatelessWidget {
  const MenuGridSection({super.key});

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
      builder: (context) => OrderDialog(coffee: coffee),
    );
  }
}

class OrderDialog extends StatefulWidget {
  final Map<String, dynamic> coffee;

  const OrderDialog({
    super.key,
    required this.coffee,
  });

  @override
  State<OrderDialog> createState() => _OrderDialogState();
}

class _OrderDialogState extends State<OrderDialog> {
  String? selectedSize;
  String? selectedAddOn;
  int quantity = 1;
  bool showSizeError = false;
  final List<String> sizes = ['Small', 'Medium', 'Large'];
  final List<String> addOns = [
    'Extra Shot (+\$0.50)',
    'Whipped Cream (+\$0.50)',
    'Caramel Drizzle (+\$0.30)',
    'Chocolate Sauce (+\$0.30)',
  ];

  // Price modifiers
  final Map<String, double> sizePrices = {
    'Small': 0.0,
    'Medium': 0.50,
    'Large': 1.00,
  };

  final Map<String, double> addOnPrices = {
    'Extra Shot (+\$0.50)': 0.50,
    'Whipped Cream (+\$0.50)': 0.50,
    'Caramel Drizzle (+\$0.30)': 0.30,
    'Chocolate Sauce (+\$0.30)': 0.30,
  };

  double get totalPrice {
    double basePrice = widget.coffee['price'];
    if (selectedSize != null) {
      basePrice += sizePrices[selectedSize]!;
    }
    if (selectedAddOn != null) {
      basePrice += addOnPrices[selectedAddOn]!;
    }
    return basePrice * quantity;
  }

  void _handleAddToCart() {
    if (selectedSize == null) {
      setState(() {
        showSizeError = true;
      });
      return;
    }

    // Calculate total price
    final total = totalPrice;

    // If size is selected, proceed with order
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Added ${quantity}x ${widget.coffee['name']} ($selectedSize)${selectedAddOn != null ? ' with $selectedAddOn' : ''} to cart - Total: \$${total.toStringAsFixed(2)}',
        ),
        backgroundColor: Colors.green[600],
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Order removed from cart'),
                backgroundColor: Colors.brown[700],
              ),
            );
          },
        ),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image Section
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.asset(
                    widget.coffee['image'],
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                // Required badge
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star,
                          size: 16,
                          color: Colors.amber[300],
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'Size Required',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Base Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.coffee['name'],
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown,
                          ),
                        ),
                      ),
                      Text(
                        'Base: \$${widget.coffee['price'].toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.brown[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.coffee['description'],
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.brown[600],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Quantity Selection
                  Row(
                    children: [
                      const Text(
                        'Quantity:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.brown),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: quantity > 1
                                  ? () => setState(() => quantity--)
                                  : null,
                              color: Colors.brown,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                quantity.toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: quantity < 10
                                  ? () => setState(() => quantity++)
                                  : null,
                              color: Colors.brown,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Size Selection with price indicators
                  DropdownButtonFormField<String>(
                    value: selectedSize,
                    decoration: InputDecoration(
                      labelText: 'Size *',
                      border: const OutlineInputBorder(),
                      errorText: showSizeError ? 'Please select a size' : null,
                      helperText: 'Price adjustments: Medium +\$0.50, Large +\$1.00',
                    ),
                    items: sizes.map((String size) {
                      return DropdownMenuItem<String>(
                        value: size,
                        child: Text('$size ${sizePrices[size]! > 0 ? "(+\$${sizePrices[size]!.toStringAsFixed(2)})" : ""}'),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        selectedSize = value;
                        showSizeError = false;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Add-ons Selection
                  DropdownButtonFormField<String>(
                    value: selectedAddOn,
                    decoration: const InputDecoration(
                      labelText: 'Add-ons (Optional)',
                      border: OutlineInputBorder(),
                      helperText: 'Customize your drink with extra toppings',
                    ),
                    items: addOns.map((String addOn) {
                      return DropdownMenuItem<String>(
                        value: addOn,
                        child: Text(addOn),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        selectedAddOn = value;
                      });
                    },
                  ),
                  const SizedBox(height: 24),

                  // Total Price Display
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.brown[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.brown[200]!),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Price:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown,
                          ),
                        ),
                        Text(
                          '\$${totalPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(color: Colors.brown[700]!),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.brown[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _handleAddToCart,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.brown[700],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Add to Cart',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}