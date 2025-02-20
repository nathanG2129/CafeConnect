import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E6D3),
      appBar: AppBar(
        title: const Text("About"),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: const [
            HeaderSection(),
            InfoSection(),
            ButtonSection(),
          ],
        ),
      ),
    );
  }
}

class HeaderSection extends StatefulWidget {
  const HeaderSection({super.key});

  @override
  State<HeaderSection> createState() => _HeaderSectionState();
}

class _HeaderSectionState extends State<HeaderSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Icon(
            Icons.coffee,
            size: 80,
            color: Colors.brown[700],
          ),
          const SizedBox(height: 16),
          const Text(
            "CafeConnect",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.brown,
            ),
          ),
          Text(
            "Your Favorite Coffee Shop",
            style: TextStyle(
              fontSize: 18,
              color: Colors.brown[400],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class InfoSection extends StatefulWidget {
  const InfoSection({super.key});

  @override
  State<InfoSection> createState() => _InfoSectionState();
}

class _InfoSectionState extends State<InfoSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(
            "About CafeConnect",
            "Welcome to CafeConnect, your neighborhood coffee destination. We pride ourselves in serving quality coffee and creating a warm, welcoming atmosphere for our community.",
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            "Features",
            "• Premium Coffee Selection\n• Comfortable Atmosphere\n• Friendly Service\n• Mobile Ordering\n• Membership Rewards",
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String content) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.brown[200]!),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
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
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.brown[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 16,
              color: Colors.brown[600],
              height: 1.5,
            ),
          ),
        ],
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
