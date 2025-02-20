import 'package:flutter/material.dart';
import 'registration_page.dart';
import 'page_two.dart';
import 'page_three.dart';
import 'about_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA9C280), // Set background color
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: const [
            DrawerHeaderWidget(),
            DrawerListView(),
          ],
        ),
      ),
      body: const Column(
        children: [
          ImageSection(),
          TextSection(),
          BodySection(),
        ],
      ),
    );
  }
}

class DrawerHeaderWidget extends StatelessWidget {
  const DrawerHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.blue,
      ),
      height: 200,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 35, color: Colors.blue),
          ),
          SizedBox(height: 10),
          Text(
            'Navigation Menu',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
          SizedBox(height: 5),
        ],
      ),
    );
  }
}

class DrawerListView extends StatelessWidget {
  const DrawerListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.home),
          title: const Text('Home'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.app_registration),
          title: const Text('Registration'),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RegistrationPage(),
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.description),
          title: const Text('Page 2'),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PageTwo(),
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.image),
          title: const Text('Page 3'),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PageThree(),
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.info),
          title: const Text('About'),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AboutPage(),
              ),
            );
          },
        ),
      ],
    );
  }
}

class ImageSection extends StatelessWidget {
  const ImageSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: AssetImage('assets/coffee.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class TextSection extends StatelessWidget {
  const TextSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white, // Ensuring readability on green background
      ),
      child: const Text(
        "Cozy Coffee Shops: Brewing Comfort and Community ☕",
        style: TextStyle(fontSize: 24),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class BodySection extends StatelessWidget {
  const BodySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white, // Ensuring readability
        ),
        child: const Center(
          child: Text(
            "Coffee shops offer a delightful world of flavors, catering to every taste and preference. From bold espresso shots and creamy lattes to the rich, nutty undertones of hazelnut and caramel-infused brews, there's a perfect cup for everyone. For those who prefer non-coffee options, matcha provides a smooth, earthy alternative packed with antioxidants, while milk-based drinks like chai lattes and hot chocolate offer warmth and comfort in every sip. To complete the experience, an array of pastries—flaky croissants, indulgent cheesecakes, and perfectly baked muffins—pairs beautifully with any drink. Whether you're a coffee lover or simply looking for a cozy treat, coffee shops are the perfect place to indulge in delicious flavors.",
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
