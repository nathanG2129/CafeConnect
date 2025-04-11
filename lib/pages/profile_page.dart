import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_activity1/models/userModel.dart';
import 'package:flutter_activity1/services/auth_service.dart';
import '../widgets/app_drawer.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _authService = AuthService();
  UserModel? _userModel;
  bool _isLoading = true;
  bool _isEditing = false;
  final _formKey = GlobalKey<FormState>();
  
  // Controllers for text fields
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _specialPreferencesController = TextEditingController();
  String? _selectedCoffeeType;
  String? _selectedVisitTime;
  
  // Validation regexes
  final _emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  final _phoneRegex = RegExp(r'^\+?[0-9\s\-\(\)\.]{8,}$');

  // Coffee types and visit times for dropdown
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
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _specialPreferencesController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    try {
      final userData = await _authService.getCurrentUserData();
      if (userData != null) {
        setState(() {
          _userModel = userData;
          _populateTextFields();
          _isLoading = false;
        });
      } else {
        _handleNoUserData();
      }
    } catch (e) {
      _handleError(e.toString());
    }
  }

  void _populateTextFields() {
    _nameController.text = _userModel?.name ?? '';
    _emailController.text = _userModel?.email ?? '';
    _phoneController.text = _userModel?.phoneNumber ?? '';
    _specialPreferencesController.text = _userModel?.specialPreferences ?? '';
    _selectedCoffeeType = _userModel?.favoriteCoffee;
    _selectedVisitTime = _userModel?.preferredVisitTime;
  }

  void _handleNoUserData() {
    setState(() {
      _isLoading = false;
    });
    
    // Use a Future.delayed to ensure the build method has completed
    Future.delayed(Duration.zero, () {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please login to view your profile'),
          backgroundColor: Colors.red[600],
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'Login',
            textColor: Colors.white,
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ),
      );
      Navigator.pop(context);
    });
  }

  void _handleError(String error) {
    setState(() {
      _isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error loading profile: $error'),
        backgroundColor: Colors.red[600],
      ),
    );
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Update the user model with new values
        _userModel!.updatePersonalInfo(
          name: _nameController.text,
          email: _emailController.text,
          phoneNumber: _phoneController.text,
        );
        
        _userModel!.updateCoffeePreferences(
          favoriteCoffee: _selectedCoffeeType,
          preferredVisitTime: _selectedVisitTime,
        );
        
        _userModel!.updateSpecialPreferences(_specialPreferencesController.text.isEmpty 
            ? null 
            : _specialPreferencesController.text);

        // Save to Firestore
        final success = await _authService.updateUserData(_userModel!);
        
        setState(() {
          _isLoading = false;
          _isEditing = false;
        });
        
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Profile updated successfully'),
              backgroundColor: Colors.green[600],
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Failed to update profile'),
              backgroundColor: Colors.red[600],
            ),
          );
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating profile: ${e.toString()}'),
            backgroundColor: Colors.red[600],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E6D3),
      appBar: AppBar(
        title: const Text("My Profile"),
        centerTitle: true,
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
        actions: [
          if (!_isLoading && _userModel != null && !_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
            ),
          if (!_isLoading && _userModel != null && _isEditing)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() {
                  _isEditing = false;
                  _populateTextFields(); // Reset to original values
                });
              },
            ),
        ],
      ),
      drawer: const AppDrawer(),
      body: _isLoading 
          ? _buildLoadingState()
          : _userModel == null 
              ? _buildNotLoggedIn() 
              : _buildProfileContent(),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Colors.brown,
          ),
          SizedBox(height: 16),
          Text(
            'Loading profile...',
            style: TextStyle(
              color: Colors.brown,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotLoggedIn() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_circle_outlined,
            size: 80,
            color: Colors.brown[300],
          ),
          const SizedBox(height: 16),
          Text(
            'You need to be logged in to view your profile',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: Colors.brown[700],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.brown[700],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Go to Login'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 24),
            _isEditing ? _buildEditForm() : _buildProfileDetails(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
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
          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              size: 60,
              color: Colors.brown,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _userModel?.name ?? 'Coffee Lover',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _userModel?.email ?? '',
            style: TextStyle(
              fontSize: 16,
              color: Colors.brown[100],
            ),
          ),
          if (_isEditing)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                'Edit Mode',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber[300],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProfileDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailCard(
          title: 'Personal Information',
          icon: Icons.person,
          children: [
            _buildDetailItem('Name', _userModel?.name ?? 'Not set'),
            _buildDetailItem('Email', _userModel?.email ?? 'Not set'),
            _buildDetailItem('Phone Number', _userModel?.phoneNumber ?? 'Not set'),
          ],
        ),
        const SizedBox(height: 16),
        _buildDetailCard(
          title: 'Coffee Preferences',
          icon: Icons.coffee,
          children: [
            _buildDetailItem('Favorite Coffee', _userModel?.favoriteCoffee ?? 'Not set'),
            _buildDetailItem('Preferred Visit Time', _userModel?.preferredVisitTime ?? 'Not set'),
          ],
        ),
        const SizedBox(height: 16),
        _buildDetailCard(
          title: 'Additional Information',
          icon: Icons.note,
          children: [
            _buildDetailItem('Special Preferences', _userModel?.specialPreferences ?? 'None'),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 4,
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
                Icon(icon, color: Colors.brown[600]),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown[800],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.brown[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEditCard(
            title: 'Personal Information',
            icon: Icons.person,
            isRequired: true,
            children: [
              TextFormField(
                controller: _nameController,
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
          const SizedBox(height: 16),
          _buildEditCard(
            title: 'Coffee Preferences',
            icon: Icons.coffee,
            isRequired: false,
            children: [
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
          const SizedBox(height: 16),
          _buildEditCard(
            title: 'Additional Information',
            icon: Icons.note,
            isRequired: false,
            children: [
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
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _saveChanges,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
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
                      'Save Changes',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditCard({
    required String title,
    required IconData icon,
    required bool isRequired,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 4,
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
                Icon(icon, color: Colors.brown[600]),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown[800],
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
            ),
            const Divider(height: 24),
            ...children,
          ],
        ),
      ),
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