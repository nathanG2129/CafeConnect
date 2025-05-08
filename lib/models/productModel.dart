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
    try {
      List<Map<String, dynamic>> sizes = [];
      List<Map<String, dynamic>> addOns = [];
      
      // Handle sizes
      if (map['sizes'] != null) {
        for (var size in map['sizes']) {
          sizes.add({
            'name': size['name'] ?? 'Unknown Size',
            'price': (size['price'] is num) ? size['price'].toDouble() : 0.0,
          });
        }
      }
      
      // Handle addOns
      if (map['addOns'] != null) {
        for (var addOn in map['addOns']) {
          addOns.add({
            'name': addOn['name'] ?? 'Unknown Add-on',
            'price': (addOn['price'] is num) ? addOn['price'].toDouble() : 0.0,
          });
        }
      }
      
      // Handle dates safely
      DateTime createdAt = DateTime.now();
      DateTime updatedAt = DateTime.now();
      
      if (map['createdAt'] != null) {
        if (map['createdAt'] is Timestamp) {
          createdAt = (map['createdAt'] as Timestamp).toDate();
        }
      }
      
      if (map['updatedAt'] != null) {
        if (map['updatedAt'] is Timestamp) {
          updatedAt = (map['updatedAt'] as Timestamp).toDate();
        }
      }
      
      return ProductModel(
        id: map['id'] ?? '',
        name: map['name'] ?? 'Unnamed Product',
        description: map['description'] ?? 'No description available',
        imagePath: map['imagePath'] ?? 'assets/coffees/default.jpg',
        basePrice: (map['basePrice'] is num) ? map['basePrice'].toDouble() : 0.0,
        isAvailable: map['isAvailable'] ?? true,
        sizes: sizes,
        addOns: addOns,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
    } catch (e) {
      // Return a default product on error
      return ProductModel.empty().copyWith(
        id: map['id'] ?? '',
        name: map['name'] ?? 'Error Loading Product',
      );
    }
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
        {'name': 'Medium', 'price': 20.0},
        {'name': 'Large', 'price': 35.0},
      ],
      addOns: [
        {'name': 'Extra Shot', 'price': 20.0},
        {'name': 'Whipped Cream', 'price': 15.0},
        {'name': 'Caramel Drizzle', 'price': 10.0},
        {'name': 'Chocolate Sauce', 'price': 10.0},
      ],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
} 