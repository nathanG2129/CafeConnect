import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_activity1/models/userModel.dart';
// import '../models/userModel.dart';
import '../../widgets/app_drawer.dart';
import '../../services/auth_service.dart';
import '../user/home_page.dart';

class RegistrationPage extends StatelessWidget {
  static const String routeName = '/register';
  
  const RegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Add a key to force the AppDrawer to rebuild and update its selection
    return Scaffold(
      key: UniqueKey(),
      backgroundColor: const Color(0xFFF5E6D3),
      appBar: AppBar(
        title: const Text("Registration"),
        centerTitle: true,
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      drawer: const AppDrawer(currentRoute: '/register'),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            _HeaderSection(),
            RegistrationForm(),
          ],
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

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
          Icon(Icons.app_registration, color: Colors.amber[300], size: 48),
          const SizedBox(height: 16),
          const Text(
            "Join Our Coffee Community",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Sign up for exclusive offers and personalized recommendations",
            textAlign: TextAlign.center,
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
  final _specialPreferencesController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? _selectedCoffeeType;
  String? _selectedVisitTime;
  bool _acceptTerms = false;
  bool _showValidationErrors = false;
  bool _isLoading = false;
  final AuthService _authService = AuthService();

  final _emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  final _phoneRegex = RegExp(r'^\+?[0-9\s\-\(\)\.]{8,}$');

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
    _specialPreferencesController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.brown.withOpacity(0.2)),
                    ),
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
                          controller: _passwordController,
                          decoration: _buildInputDecoration(
                            'Password',
                            Icons.lock,
                            hintText: 'Enter your password',
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _confirmPasswordController,
                          decoration: _buildInputDecoration(
                            'Confirm Password',
                            Icons.lock_outline,
                            hintText: 'Confirm your password',
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
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
                            LengthLimitingTextInputFormatter(16),
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
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.brown.withOpacity(0.2)),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildSectionTitle('Coffee Preferences', isRequired: false),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.brown[100],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Optional',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.brown[700],
                                  fontWeight: FontWeight.w500,
                                ),
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
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.brown.withOpacity(0.2)),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildSectionTitle('Additional Information', isRequired: false),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.brown[100],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Optional',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.brown[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          maxLines: 3,
                          controller: _specialPreferencesController,
                          decoration: _buildInputDecoration(
                            'Special Preferences / Allergies',
                            Icons.note,
                            hintText: 'Tell us about any dietary restrictions or preferences',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: !_acceptTerms && _showValidationErrors
                            ? Colors.red[400]!
                            : Colors.brown.withOpacity(0.2),
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CheckboxListTile(
                          title: const Text(
                            'I accept the terms and conditions',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.brown,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'By checking this box, you agree to our Terms of Service and Privacy Policy',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.brown[600],
                                ),
                              ),
                              if (!_acceptTerms && _showValidationErrors) ...[
                                const SizedBox(height: 4),
                                Text(
                                  'Please accept the terms and conditions to continue',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.red[400],
                                  ),
                                ),
                              ],
                            ],
                          ),
                          value: _acceptTerms,
                          onChanged: (bool? value) {
                            setState(() {
                              _acceptTerms = value ?? false;
                              if (_acceptTerms) {
                                _showValidationErrors = false;
                              }
                            });
                          },
                          activeColor: Colors.brown[700],
                          checkColor: Colors.white,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                  ),
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
                  onPressed: _isLoading ? null : () async {
                    setState(() {
                      _showValidationErrors = true;
                    });
                    if (_formKey.currentState!.validate() && _acceptTerms) {
                      setState(() {
                        _isLoading = true;
                      });
                      
                      final newUser = UserModel(
                        name: _fullNameController.text,
                        email: _emailController.text,
                        phoneNumber: _phoneController.text,
                        favoriteCoffee: _selectedCoffeeType,
                        preferredVisitTime: _selectedVisitTime,
                        specialPreferences: _specialPreferencesController.text.isNotEmpty 
                            ? _specialPreferencesController.text 
                            : null,
                        role: 'user',
                      );
                      
                      try {
                        final result = await _authService.registerUser(
                          email: _emailController.text,
                          password: _passwordController.text,
                          userModel: newUser,
                        );
                        
                        if (!mounted) return;
                        setState(() {
                          _isLoading = false;
                        });
                        
                        if (result != null) {
                          // Clear the app drawer cache to reflect the new logged-in state
                          AppDrawerState.clearCache();
                          
                          if (!mounted) return;
                          
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const HomePage()),
                          );
                          
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Registration Successful! Welcome to CafeConnect.'),
                              backgroundColor: Colors.green[600],
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        } else {
                          if (!mounted) return;
                          
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Registration Failed. Please try again.'),
                              backgroundColor: Colors.red[600],
                            ),
                          );
                        }
                      } catch (e) {
                        if (!mounted) return;
                        setState(() {
                          _isLoading = false;
                        });
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error: ${e.toString()}'),
                            backgroundColor: Colors.red[600],
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(120, 45),
                    backgroundColor: Colors.brown[700],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading 
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Submit',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.brown[700],
          ),
        ),
        if (isRequired) ...[
          const SizedBox(width: 4),
          Icon(
            Icons.star,
            size: 12,
            color: Colors.red[400],
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
        color: Colors.grey.withOpacity(0.6),
        fontSize: 14,
      ),
      prefixIcon: Icon(icon, color: Colors.brown[600]),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      filled: true,
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.brown[200]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.brown[700]!, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red[400]!),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red[400]!, width: 2),
      ),
      labelStyle: TextStyle(
        color: Colors.brown[600],
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
