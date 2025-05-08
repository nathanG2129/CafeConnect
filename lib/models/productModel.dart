import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id;
  final String name;
  final String description;
  final String imagePath;
  final double basePrice;
  final bool isAvailable;
  final List<Map<String, dynamic>> sizes;
  final List<Map<String, dynamic>> addOns;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imagePath,
    required this.basePrice,
    required this.isAvailable,
    required this.sizes,
    required this.addOns,
    required this.createdAt,
    required this.updatedAt,
  });

  // Create a copy of the product with updated properties
  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    String? imagePath,
    double? basePrice,
    bool? isAvailable,
    List<Map<String, dynamic>>? sizes,
    List<Map<String, dynamic>>? addOns,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      basePrice: basePrice ?? this.basePrice,
      isAvailable: isAvailable ?? this.isAvailable,
      sizes: sizes ?? this.sizes,
      addOns: addOns ?? this.addOns,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Convert ProductModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imagePath': imagePath,
      'basePrice': basePrice,
      'isAvailable': isAvailable,
      'sizes': sizes,
      'addOns': addOns,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // Create ProductModel from Firestore Map
  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      imagePath: map['imagePath'],
      basePrice: map['basePrice'],
      isAvailable: map['isAvailable'],
      sizes: List<Map<String, dynamic>>.from(map['sizes']),
      addOns: List<Map<String, dynamic>>.from(map['addOns']),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }

  // Create an empty product with default values
  factory ProductModel.empty() {
    return ProductModel(
      id: '',
      name: '',
      description: '',
      imagePath: 'assets/coffees/default.jpg',
      basePrice: 0.0,
      isAvailable: true,
      sizes: [
        {'name': 'Small', 'price': 0.0},
        {'name': 'Medium', 'price': 0.5},
        {'name': 'Large', 'price': 1.0},
      ],
      addOns: [
        {'name': 'Extra Shot', 'price': 0.5},
        {'name': 'Whipped Cream', 'price': 0.5},
        {'name': 'Caramel Drizzle', 'price': 0.3},
        {'name': 'Chocolate Sauce', 'price': 0.3},
      ],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
} 