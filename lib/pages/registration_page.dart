import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E6D3),
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
            RegistrationForm(),
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
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _selectedCoffeeType;
  String? _selectedVisitTime;
  bool _acceptTerms = false;

  final _emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  final _phoneRegex = RegExp(r'^\+?[(]?[0-9]+[)]?[-\s.]?[0-9]+[-\s.]?[0-9]+$');

  final List<String> _coffeeTypes = [
    'Espresso',
    'Cappuccino',
    'Latte',
    'Americano',
    'Cold Brew',
    'Mocha',
    'Macchiato',
  ];

  final List<String> _visitTimes = [
    'Morning (6AM - 11AM)',
    'Noon (11AM - 2PM)',
    'Afternoon (2PM - 5PM)',
    'Evening (5PM - 9PM)',
  ];

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle('Personal Information', isRequired: true),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _fullNameController,
                          decoration: _buildInputDecoration(
                            'Full Name',
                            Icons.person,
                            hintText: 'Enter your full name',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your full name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _emailController,
                          decoration: _buildInputDecoration(
                            'Email',
                            Icons.email,
                            hintText: 'example@email.com',
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!_emailRegex.hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _phoneController,
                          decoration: _buildInputDecoration(
                            'Phone Number',
                            Icons.phone,
                            hintText: '+63 XXX XXX XXXX',
                          ),
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9\+\(\)\-\s\.]')),
                            LengthLimitingTextInputFormatter(15),
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            String digitsOnly = value.replaceAll(RegExp(r'\D'), '');
                            if (digitsOnly.length < 10) {
                              return 'Please enter a valid phone number';
                            }
                            if (!_phoneRegex.hasMatch(value)) {
                              return 'Please enter a valid phone number format';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildSectionTitle('Preferences', isRequired: false),
                            ),
                            Text(
                              'You may fill this up later!',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _selectedCoffeeType,
                          decoration: _buildInputDecoration('Favorite Coffee', Icons.coffee),
                          items: _coffeeTypes.map((String type) {
                            return DropdownMenuItem<String>(
                              value: type,
                              child: Text(type),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedCoffeeType = newValue;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _selectedVisitTime,
                          decoration: _buildInputDecoration('Preferred Visit Time', Icons.access_time),
                          items: _visitTimes.map((String time) {
                            return DropdownMenuItem<String>(
                              value: time,
                              child: Text(time),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedVisitTime = newValue;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildSectionTitle('Additional Information', isRequired: false),
                            ),
                            Text(
                              'Optional',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          maxLines: 3,
                          decoration: _buildInputDecoration('Special Preferences / Allergies', Icons.note),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                CheckboxListTile(
                  title: const Text(
                    'I accept the terms and conditions',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text(
                    'By checking this box, you agree to our Terms of Service and Privacy Policy',
                    style: TextStyle(fontSize: 12),
                  ),
                  value: _acceptTerms,
                  onChanged: (bool? value) {
                    setState(() {
                      _acceptTerms = value ?? false;
                    });
                  },
                  activeColor: Colors.brown,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                ),
              ],
            ),
          ),
          Padding(
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Back'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (!_acceptTerms) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please accept the terms and conditions'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Registration Submitted!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(120, 45),
                    backgroundColor: Colors.green[400],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, {required bool isRequired}) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.brown,
          ),
        ),
        if (isRequired) ...[
          const SizedBox(width: 4),
          const Text(
            '*',
            style: TextStyle(
              color: Colors.red,
              fontSize: 20,
            ),
          ),
        ],
      ],
    );
  }

  InputDecoration _buildInputDecoration(String label, IconData icon, {String? hintText}) {
    return InputDecoration(
      labelText: label,
      hintText: hintText,
      hintStyle: TextStyle(
        color: Colors.grey.withOpacity(0.5),
      ),
      prefixIcon: Icon(icon, color: Colors.brown),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      filled: true,
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.brown[200]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.brown, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.red[400]!),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.red[400]!, width: 2),
      ),
    );
  }
}
