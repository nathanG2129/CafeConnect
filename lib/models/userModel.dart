class UserModel {
  String? id;
  String? name;
  String? email;
  String? phoneNumber;
  String? favoriteCoffee;
  String? preferredVisitTime;
  String? specialPreferences;
  String role;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.phoneNumber,
    this.favoriteCoffee,
    this.preferredVisitTime,
    this.specialPreferences,
    this.role = 'user',
  });

  // Update personal information
  void updatePersonalInfo({
    String? name,
    String? email,
    String? phoneNumber,
  }) {
    this.name = name ?? this.name;
    this.email = email ?? this.email;
    this.phoneNumber = phoneNumber ?? this.phoneNumber;
  }

  // Update coffee preferences
  void updateCoffeePreferences({
    String? favoriteCoffee,
    String? preferredVisitTime,
  }) {
    this.favoriteCoffee = favoriteCoffee ?? this.favoriteCoffee;
    this.preferredVisitTime = preferredVisitTime ?? this.preferredVisitTime;
  }

  // Update special preferences
  void updateSpecialPreferences(String? specialPreferences) {
    this.specialPreferences = specialPreferences;
  }

  // Update user role
  void updateRole(String role) {
    this.role = role;
  }

  // Convert UserModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'favoriteCoffee': favoriteCoffee,
      'preferredVisitTime': preferredVisitTime,
      'specialPreferences': specialPreferences,
      'role': role,
    };
  }

  // Create UserModel from Firestore Map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      favoriteCoffee: map['favoriteCoffee'],
      preferredVisitTime: map['preferredVisitTime'],
      specialPreferences: map['specialPreferences'],
      role: map['role'] ?? 'user', // Default to 'user' if role is not present
    );
  }
}