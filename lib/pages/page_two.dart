import 'package:flutter/material.dart';

class PageTwo extends StatelessWidget {
  const PageTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFA9C280), // Set background color
      appBar: AppBar(
        title: Text("PAGE 2"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                color: Colors.white, // Ensuring contrast
              ),
              child: Center(
                child: Text("IMG", style: TextStyle(fontSize: 20)),
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
                color: Colors.white,
              ),
              child: Center(
                child: Text("IMG", style: TextStyle(fontSize: 20)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FormSection extends StatelessWidget {
  const FormSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Field 1',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white, // Ensuring readability
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Field 2',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Field 3',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Field 4',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
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
