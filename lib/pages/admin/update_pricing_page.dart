import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/app_drawer.dart';

class UpdatePricingPage extends StatefulWidget {
  static const String routeName = '/update-pricing';

  const UpdatePricingPage({super.key});

  @override
  State<UpdatePricingPage> createState() => _UpdatePricingPageState();
}

class _UpdatePricingPageState extends State<UpdatePricingPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;
  bool _isSuccess = false;
  String _errorMessage = '';

  // Price configuration for a budget coffee shop
  final List<Map<String, dynamic>> _coffeeMenu = [
    {
      'id': 'Ah0vgs6Rdk1DeKTYVT9L',
      'name': 'Espresso',
      'description': 'Strong and concentrated coffee shot',
      'imagePath': 'assets/coffees/expresso.jpg',
      'basePrice': 89.0, // ₱89
    },
    {
      'id': '1dsArRulc1VP2he6M6g8',
      'name': 'Cappuccino',
      'description': 'Equal parts espresso, steamed milk, and milk foam',
      'imagePath': 'assets/coffees/capuccino.jpg',
      'basePrice': 119.0, // ₱119
    },
    {
      'id': 'RXPuso9dC8GFOxcL9FCr',
      'name': 'Latte',
      'description': 'Espresso with steamed milk and light foam',
      'imagePath': 'assets/coffees/latte.jpg',
      'basePrice': 109.0, // ₱109
    },
    {
      'id': 'nq9k0p2q0QiYuvUHxYUt',
      'name': 'Americano',
      'description': 'Espresso diluted with hot water',
      'imagePath': 'assets/coffees/americano.jpg',
      'basePrice': 95.0, // ₱95
    },
    {
      'id': 'oDC2EpEaQy8rtOE9b2O8',
      'name': 'Mocha',
      'description': 'Espresso with chocolate and steamed milk',
      'imagePath': 'assets/coffees/mocha.jpg',
      'basePrice': 125.0, // ₱125
    },
    {
      'id': 'sIZbyuOIZv7ssjLiHxN2',
      'name': 'Cold Brew',
      'description': 'Smooth, cold-steeped coffee',
      'imagePath': 'assets/coffees/coldbrew.jpg',
      'basePrice': 115.0, // ₱115
    },
    {
      'id': 'y8JMF3MoBWTf4XjLZbQo',
      'name': 'Caramel Macchiato',
      'description': 'Vanilla-flavored drink marked with espresso and caramel',
      'imagePath': 'assets/coffees/macchiato.jpg',
      'basePrice': 135.0, // ₱135
    },
  ];

  final List<Map<String, dynamic>> _addOns = [
    {'name': 'Extra Shot', 'price': 20.0}, // ₱20
    {'name': 'Whipped Cream', 'price': 15.0}, // ₱15
    {'name': 'Caramel Drizzle', 'price': 10.0}, // ₱10
    {'name': 'Chocolate Sauce', 'price': 10.0}, // ₱10
  ];

  final List<Map<String, dynamic>> _sizes = [
    {'name': 'Small', 'price': 0.0},
    {'name': 'Medium', 'price': 20.0}, // ₱20
    {'name': 'Large', 'price': 35.0}, // ₱35
  ];

  Future<void> _updatePricing() async {
    setState(() {
      _isLoading = true;
      _isSuccess = false;
      _errorMessage = '';
    });

    try {
      // Batch write to ensure all updates succeed or fail together
      WriteBatch batch = _firestore.batch();
      
      // Update each coffee product
      for (var coffee in _coffeeMenu) {
        final productRef = _firestore.collection('products').doc(coffee['id']);
        
        // First check if the document exists
        final docSnapshot = await productRef.get();
        
        if (docSnapshot.exists) {
          // Update existing document with the new price
          batch.update(productRef, {
            'name': coffee['name'],
            'description': coffee['description'],
            'imagePath': coffee['imagePath'],
            'basePrice': coffee['basePrice'],
            'updatedAt': FieldValue.serverTimestamp(),
            // We don't directly update addOns here since they're array elements that need updating individually
          });
          
          // Get the existing add-ons from the document
          if (docSnapshot.data()!.containsKey('addOns')) {
            // Update the add-ons prices
            List<dynamic> existingAddOns = List.from(docSnapshot.data()!['addOns']);
            
            // Update prices for each add-on we have in our list
            for (int i = 0; i < existingAddOns.length; i++) {
              if (i < _addOns.length) {
                // Find the matching add-on by name
                String existingName = existingAddOns[i]['name'];
                Map<String, dynamic>? matchingAddOn = _addOns.firstWhere(
                  (addOn) => addOn['name'].contains(existingName) || existingName.contains(addOn['name']),
                  orElse: () => {'name': '', 'price': 0.0},
                );
                
                // Only update if we found a matching add-on
                if (matchingAddOn['name'].isNotEmpty) {
                  // Update the price of this add-on
                  existingAddOns[i]['price'] = matchingAddOn['price'];
                }
              }
            }
            
            // Update the add-ons array in the document
            batch.update(productRef, {'addOns': existingAddOns});
          }
          
          // Update sizes if they exist
          if (docSnapshot.data()!.containsKey('sizes')) {
            List<dynamic> existingSizes = List.from(docSnapshot.data()!['sizes']);
            
            // Update prices for each size based on our new pricing
            for (int i = 0; i < existingSizes.length; i++) {
              if (i < _sizes.length) {
                // Match by name
                String existingName = existingSizes[i]['name'];
                Map<String, dynamic>? matchingSize = _sizes.firstWhere(
                  (size) => size['name'] == existingName,
                  orElse: () => {'name': '', 'price': 0.0},
                );
                
                // Only update if we found a match
                if (matchingSize['name'].isNotEmpty) {
                  existingSizes[i]['price'] = matchingSize['price'];
                }
              }
            }
            
            // Update the sizes array
            batch.update(productRef, {'sizes': existingSizes});
          }
          
        } else {
          // Create new document with full structure
          batch.set(productRef, {
            'name': coffee['name'],
            'description': coffee['description'],
            'imagePath': coffee['imagePath'],
            'basePrice': coffee['basePrice'],
            'sizes': _sizes,
            'addOns': _addOns,
            'isAvailable': true,
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          });
        }
      }
      
      // Commit all updates
      await batch.commit();
      
      setState(() {
        _isLoading = false;
        _isSuccess = true;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E6D3),
      appBar: AppBar(
        title: const Text("Update Menu Pricing"),
        centerTitle: true,
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      drawer: const AppDrawer(currentRoute: '/update-pricing'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.price_change, color: Colors.amber[300], size: 32),
                      const SizedBox(width: 12),
                      const Text(
                        'Budget Coffee Pricing',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Update your coffee menu with affordable prices',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.brown[100],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Menu preview
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Menu Preview',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown[800],
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...List.generate(_coffeeMenu.length, (index) {
                      final coffee = _coffeeMenu[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 80,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  color: Colors.brown[100],
                                  child: Center(
                                    child: Icon(
                                      Icons.coffee,
                                      size: 32,
                                      color: Colors.brown[700],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    coffee['name'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    coffee['description'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '₱${coffee['basePrice'].toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.brown[700],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    const Divider(),
                    const SizedBox(height: 12),
                    
                    // Add-ons section
                    Text(
                      'Add-ons',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown[800],
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...List.generate(_addOns.length, (index) {
                      final addOn = _addOns[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(addOn['name']),
                            Text('₱${addOn['price'].toStringAsFixed(2)}'),
                          ],
                        ),
                      );
                    }),
                    
                    const SizedBox(height: 12),
                    
                    // Size modifiers
                    Text(
                      'Size Modifiers',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown[800],
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...List.generate(_sizes.length, (index) {
                      final size = _sizes[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(size['name']),
                            Text(size['price'] == 0.0 ? 'Base price' : '+₱${size['price'].toStringAsFixed(2)}'),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Status message
            if (_isSuccess)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green[400]!),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Menu prices updated successfully!',
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                  ],
                ),
              ),
            
            if (_errorMessage.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red[400]!),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Error: $_errorMessage',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            
            const SizedBox(height: 24),
            
            // Update button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _updatePricing,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.brown[700],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Update Menu Prices',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 