import 'package:flutter/material.dart';

class PageThree extends StatelessWidget {
  const PageThree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFA9C280), // Set background color
      appBar: AppBar(
        title: Text("PAGE 3"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Column(
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
        margin: EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text("IMAGE", style: TextStyle(fontSize: 20)),
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
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.all(16),
        child: Text(
          "There’s something special about the cozy atmosphere of a coffee shop—the soothing hum of conversation, the rich aroma of freshly brewed coffee, and the warm glow of ambient lighting. Whether you're curled up with a book, catching up with a friend, or simply enjoying a quiet moment alone, coffee shops provide the perfect escape from the outside world. Yet, no matter how much we savor the experience, a good drink never seems to last long. A perfectly brewed coffee, a creamy matcha, or a frothy latte can disappear in just a few sips, leaving behind only the lingering taste and a desire for just one more. In the end, it’s not just about the drink—it’s about the moment of comfort it brings.",
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
      padding: EdgeInsets.all(16),
      child: ElevatedButton(
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
    );
  }
}
