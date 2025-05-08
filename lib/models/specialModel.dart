import 'package:cloud_firestore/cloud_firestore.dart';

enum DiscountType {
  fixedPrice, // Set a specific price
  percentOff, // Take a percentage off the original price
  amountOff,  // Take a fixed amount off the original price
}

class SpecialModel {
  final String id;
  final String name;
  final String description;
  final double price;             // Final price after discount or custom price
  final DiscountType discountType;
  final double discountValue;     // Either percentage or amount off
  final double originalPrice;     // Original price before discount
  final DateTime startDate;
  final DateTime endDate;
  final String? productId;        // Optional - reference to an existing product
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  SpecialModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.discountType,
    required this.discountValue,
    required this.originalPrice,
    required this.startDate,
    required this.endDate,
    this.productId,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  // Create a copy of the special with updated properties
  SpecialModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    DiscountType? discountType,
    double? discountValue,
    double? originalPrice,
    DateTime? startDate,
    DateTime? endDate,
    String? productId,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SpecialModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      discountType: discountType ?? this.discountType,
      discountValue: discountValue ?? this.discountValue,
      originalPrice: originalPrice ?? this.originalPrice,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      productId: productId ?? this.productId,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Convert DiscountType to string for Firestore
  static String discountTypeToString(DiscountType type) {
    switch (type) {
      case DiscountType.fixedPrice:
        return 'fixedPrice';
      case DiscountType.percentOff:
        return 'percentOff';
      case DiscountType.amountOff:
        return 'amountOff';
      default:
        return 'fixedPrice';
    }
  }

  // Convert string from Firestore to DiscountType
  static DiscountType stringToDiscountType(String? typeString) {
    switch (typeString) {
      case 'percentOff':
        return DiscountType.percentOff;
      case 'amountOff':
        return DiscountType.amountOff;
      case 'fixedPrice':
      default:
        return DiscountType.fixedPrice;
    }
  }

  // Get a human-readable discount description
  String getDiscountDescription() {
    switch (discountType) {
      case DiscountType.percentOff:
        return '${discountValue.toStringAsFixed(0)}% off';
      case DiscountType.amountOff:
        return '₱${discountValue.toStringAsFixed(2)} off';
      case DiscountType.fixedPrice:
        return 'Special price: ₱${price.toStringAsFixed(2)}';
    }
  }

  // Calculate the final price based on discount type and value
  static double calculatePrice(DiscountType discountType, double originalPrice, double discountValue) {
    switch (discountType) {
      case DiscountType.percentOff:
        // Apply percentage discount
        final discount = (originalPrice * discountValue) / 100;
        return (originalPrice - discount) >= 0 ? (originalPrice - discount) : 0;
        
      case DiscountType.amountOff:
        // Apply fixed amount off
        return (originalPrice - discountValue) >= 0 ? (originalPrice - discountValue) : 0;
        
      case DiscountType.fixedPrice:
        // Use the discount value as the final price
        return discountValue;
    }
  }

  // Convert SpecialModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'discountType': discountTypeToString(discountType),
      'discountValue': discountValue,
      'originalPrice': originalPrice,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'productId': productId,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // Create SpecialModel from Firestore Map
  factory SpecialModel.fromMap(Map<String, dynamic> map) {
    try {
      // Handle dates safely
      DateTime startDate = DateTime.now();
      DateTime endDate = DateTime.now().add(const Duration(days: 7));
      DateTime createdAt = DateTime.now();
      DateTime updatedAt = DateTime.now();
      
      if (map['startDate'] != null && map['startDate'] is Timestamp) {
        startDate = (map['startDate'] as Timestamp).toDate();
      }
      
      if (map['endDate'] != null && map['endDate'] is Timestamp) {
        endDate = (map['endDate'] as Timestamp).toDate();
      }
      
      if (map['createdAt'] != null && map['createdAt'] is Timestamp) {
        createdAt = (map['createdAt'] as Timestamp).toDate();
      }
      
      if (map['updatedAt'] != null && map['updatedAt'] is Timestamp) {
        updatedAt = (map['updatedAt'] as Timestamp).toDate();
      }
      
      // Get discount type
      final discountType = stringToDiscountType(map['discountType'] as String?);
      
      // Get numeric values safely
      final double originalPrice = (map['originalPrice'] is num) 
          ? (map['originalPrice'] as num).toDouble() 
          : 0.0;
          
      final double discountValue = (map['discountValue'] is num) 
          ? (map['discountValue'] as num).toDouble() 
          : 0.0;
          
      // Get price (final price) value safely
      double price = (map['price'] is num) 
          ? (map['price'] as num).toDouble() 
          : 0.0;
      
      return SpecialModel(
        id: map['id'] ?? '',
        name: map['name'] ?? 'Unnamed Special',
        description: map['description'] ?? 'No description available',
        price: price,
        discountType: discountType,
        discountValue: discountValue,
        originalPrice: originalPrice,
        startDate: startDate,
        endDate: endDate,
        productId: map['productId'],
        isActive: map['isActive'] ?? true,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
    } catch (e) {
      // Return a default special on error
      return SpecialModel.empty().copyWith(
        id: map['id'] ?? '',
        name: map['name'] ?? 'Error Loading Special',
      );
    }
  }

  // Create an empty special with default values
  factory SpecialModel.empty() {
    final now = DateTime.now();
    return SpecialModel(
      id: '',
      name: '',
      description: '',
      price: 0.0,
      discountType: DiscountType.fixedPrice,
      discountValue: 0.0,
      originalPrice: 0.0,
      startDate: now,
      endDate: now.add(const Duration(days: 7)),
      productId: null,
      isActive: true,
      createdAt: now,
      updatedAt: now,
    );
  }
} 