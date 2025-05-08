import 'package:flutter/foundation.dart';

class OrderItemModel {
  final String id;
  final String coffeeName;
  final String size;
  final String? addOn;
  final int quantity;
  final double basePrice;
  final double totalPrice;
  final String imagePath;

  OrderItemModel({
    required this.id,
    required this.coffeeName,
    required this.size,
    this.addOn,
    required this.quantity,
    required this.basePrice,
    required this.totalPrice,
    required this.imagePath,
  });

  // Create a copy with updated properties
  OrderItemModel copyWith({
    String? id,
    String? coffeeName,
    String? size,
    String? addOn,
    int? quantity,
    double? basePrice,
    double? totalPrice,
    String? imagePath,
  }) {
    return OrderItemModel(
      id: id ?? this.id,
      coffeeName: coffeeName ?? this.coffeeName,
      size: size ?? this.size,
      addOn: addOn ?? this.addOn,
      quantity: quantity ?? this.quantity,
      basePrice: basePrice ?? this.basePrice,
      totalPrice: totalPrice ?? this.totalPrice,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  // Convert OrderItemModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'coffeeName': coffeeName,
      'size': size,
      'addOn': addOn,
      'quantity': quantity,
      'basePrice': basePrice,
      'totalPrice': totalPrice,
      'imagePath': imagePath,
    };
  }

  // Create OrderItemModel from Firestore Map
  factory OrderItemModel.fromMap(Map<String, dynamic> map) {
    return OrderItemModel(
      id: map['id'],
      coffeeName: map['coffeeName'],
      size: map['size'],
      addOn: map['addOn'],
      quantity: map['quantity'],
      basePrice: map['basePrice'],
      totalPrice: map['totalPrice'],
      imagePath: map['imagePath'],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OrderItemModel &&
        other.id == id &&
        other.coffeeName == coffeeName &&
        other.size == size &&
        other.addOn == addOn &&
        other.quantity == quantity &&
        other.basePrice == basePrice &&
        other.totalPrice == totalPrice &&
        other.imagePath == imagePath;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        coffeeName.hashCode ^
        size.hashCode ^
        addOn.hashCode ^
        quantity.hashCode ^
        basePrice.hashCode ^
        totalPrice.hashCode ^
        imagePath.hashCode;
  }
} 