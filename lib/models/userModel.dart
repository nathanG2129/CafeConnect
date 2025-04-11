class UserModel {
  String? id;
  String? name;
  String? email;
  String? phoneNumber;
  String? favoriteCoffee;
  String? preferredVisitTime;
  String? specialPreferences;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.phoneNumber,
    this.favoriteCoffee,
    this.preferredVisitTime,
    this.specialPreferences,
  });

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
    );
  }
}