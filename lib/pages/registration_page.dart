import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final _fullName = TextEditingController();
final _phoneNumber = TextEditingController();
bool _validateFname = false;
bool _validateFNumber = false;

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E6D3), // Warm coffee-themed background
      appBar: AppBar(
        title: const Text("Registration"),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            // RegistrationForm(),
            // ButtonSection(),
            ValidationSections()
          ],
        ),
      ),
    );
  }
}

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // First row - full width
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Full Name',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          
          // Second row - full width
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          
          // Third row - two fields
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Favorite Coffee Type',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Preferred Visit Time',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Fourth row - three fields
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Rewards Number',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Phone',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Preferred Branch',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Last row - full width with multiple lines
          TextFormField(
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Special Preferences / Allergies',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
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

class ValidationSections extends StatefulWidget{
  const ValidationSections({super.key});

  @override
  _ValidationSections createState() => _ValidationSections();
}

class _ValidationSections extends State<ValidationSections> {
  @override

  Widget build(BuildContext context){
    return Padding(padding:
    const EdgeInsets.all(30),
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 16,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(child:
                TextField(
                  controller: _fullName,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(11),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    border: const OutlineInputBorder(),
                    hintStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                    errorText: _validateFname ? 'Please enter your full name' : null
                  ),
                ),
              ),
              Expanded(child:
                TextField(
                  controller: _phoneNumber,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(11),
                    FilteringTextInputFormatter(RegExp(r'^[0-9]+$'), allow: true),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: const OutlineInputBorder(),
                    hintStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                    hintMaxLines: 2,
                      errorText: _validateFNumber ? 'Phone number cannot be empty/null' : null
                  ),
                ),
              ),
              Expanded(child:
                ElevatedButton(onPressed: () {
                  setState(() {
                    validateSections();
                  });
                },
                    child: const Text('Submit'),
                )
              ),
            ],
          )
        ],
      ),
    );
  }
}

void validateSections() {
  if(_fullName.text.isEmpty){
    _validateFname = true;
  } else {
    _validateFname = false;
  }
  if(_phoneNumber.text.isEmpty){
    _validateFNumber = true;
  } else {
    _validateFNumber = false;
  }
}

class _ButtonSectionState extends State<ButtonSection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
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
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Student Registration Submitted!')),
              );
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(120, 45),
              backgroundColor: Colors.green[400],
              foregroundColor: Colors.white,
            ),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
