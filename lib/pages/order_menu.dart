import 'package:flutter/material.dart';

class OrderMenuPage extends StatelessWidget {
  const OrderMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E6D3), // Warm coffee-themed background
      appBar: AppBar(
        title: const Text("Order Menu"),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: const [
            ImageSection(),
            FormSection(),
            ButtonSection(),
          ],
        ),
      ),
    );
  }
}

class ImageSection extends StatelessWidget {
  const ImageSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 150,
              margin: EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: AssetImage('assets/coffee2.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 150,
              margin: EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: AssetImage('assets/coffee3.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FormSection extends StatefulWidget {
  const FormSection({super.key});

  @override
  State<FormSection> createState() => _FormSectionState();
}

class _FormSectionState extends State<FormSection> {
  String? selectedDrink;
  String? selectedSize;
  String? selectedAddOn;
  String? selectedInstruction;

  final List<String> drinks = [
    'Espresso',
    'Cappuccino',
    'Latte',
    'Americano',
    'Mocha',
    'Cold Brew',
    'Frappuccino',
    'Caramel Macchiato',
    'Flat White',
  ];

  final List<String> sizes = [
    'Small (8 oz)',
    'Medium (12 oz)',
    'Large (16 oz)',
    'Extra Large (20 oz)',
  ];

  final List<String> addOns = [
    'Extra Shot',
    'Vanilla Syrup',
    'Caramel Syrup',
    'Hazelnut Syrup',
    'Whipped Cream',
    'Cinnamon Powder',
    'Chocolate Drizzle',
    'Soy Milk',
    'Almond Milk',
  ];

  final List<String> instructions = [
    'Extra Hot',
    'Less Ice',
    'Sugar Free',
    'Light Foam',
    'Extra Foam',
    'Double Cup',
    'No Whip',
    'Extra Whip',
    'Stirred',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedDrink,
                      hint: const Text('Select Drink'),
                      isExpanded: true,
                      items: drinks.map((String drink) {
                        return DropdownMenuItem<String>(
                          value: drink,
                          child: Text(drink),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedDrink = newValue;
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedSize,
                      hint: const Text('Select Size'),
                      isExpanded: true,
                      items: sizes.map((String size) {
                        return DropdownMenuItem<String>(
                          value: size,
                          child: Text(size),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedSize = newValue;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedAddOn,
                      hint: const Text('Select Add-on'),
                      isExpanded: true,
                      items: addOns.map((String addOn) {
                        return DropdownMenuItem<String>(
                          value: addOn,
                          child: Text(addOn),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedAddOn = newValue;
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedInstruction,
                      hint: const Text('Special Instructions'),
                      isExpanded: true,
                      items: instructions.map((String instruction) {
                        return DropdownMenuItem<String>(
                          value: instruction,
                          child: Text(instruction),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedInstruction = newValue;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ButtonSection extends StatelessWidget {
  const ButtonSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              minimumSize: Size(120, 45),
              backgroundColor: Colors.red[400],
              foregroundColor: Colors.white,
            ),
            child: Text('Back'),
          ),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Profile Updated!')),
              );
            },
            style: ElevatedButton.styleFrom(
              minimumSize: Size(120, 45),
              backgroundColor: Colors.green[400],
              foregroundColor: Colors.white,
            ),
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
}