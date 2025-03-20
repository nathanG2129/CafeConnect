import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class CoffeeGuidePage extends StatelessWidget {
  const CoffeeGuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E6D3), // Warm coffee-themed background
      appBar: AppBar(
        title: const Text("Coffee Guide"),
        centerTitle: true,
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      drawer: const AppDrawer(),
      body: const Column(
        children: [
          ImageSection(),
          TextSection(),
          ButtonSection(),
        ],
      ),
    );
  }
}

class ImageSection extends StatefulWidget {
  const ImageSection({super.key});

  @override
  State<ImageSection> createState() => _ImageSectionState();
}

class _ImageSectionState extends State<ImageSection> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
          image: const DecorationImage(
            image: AssetImage('assets/coffee3.jpg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class TextSection extends StatefulWidget {
  const TextSection({super.key});

  @override
  State<TextSection> createState() => _TextSectionState();
}

class _TextSectionState extends State<TextSection> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        child: const Text(
          "Discover the Art of Coffee Making\n\n"
          "From light to dark roasts, each coffee bean tells a unique story. Our expert baristas craft each drink with precision and care, ensuring the perfect balance of flavors.\n\n"
          "Visit us to explore our signature drinks and learn about different brewing methods!",
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class ButtonSection extends StatefulWidget {
  const ButtonSection({super.key});

  @override
  State<ButtonSection> createState() => _ButtonSectionState();
}

class _ButtonSectionState extends State<ButtonSection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(120, 45),
          backgroundColor: Colors.red[400],
          foregroundColor: Colors.white,
        ),
        child: const Text('Back'),
      ),
    );
  }
}
