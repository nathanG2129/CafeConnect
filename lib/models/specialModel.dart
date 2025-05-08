import 'package:cloud_firestore/cloud_firestore.dart';

class SpecialModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String? relatedProductId; // Optional link to existing product
  final bool isActive;
  final DateTime startDate;
  final DateTime? endDate; // Optional
  final DateTime createdAt;
  final DateTime updatedAt;

  SpecialModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.relatedProductId,
    required this.isActive,
    required this.startDate,
    this.endDate,
    required this.createdAt,
    required this.updatedAt,
  });

  // Create a copy of the special with updated properties
  SpecialModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? relatedProductId,
    bool? isActive,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SpecialModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      relatedProductId: relatedProductId ?? this.relatedProductId,
      isActive: isActive ?? this.isActive,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Convert SpecialModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'relatedProductId': relatedProductId,
      'isActive': isActive,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': endDate != null ? Timestamp.fromDate(endDate!) : null,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // Create SpecialModel from Firestore Map
  factory SpecialModel.fromMap(Map<String, dynamic> map) {
    try {
      // Handle dates safely
      DateTime createdAt = DateTime.now();
      DateTime updatedAt = DateTime.now();
      DateTime startDate = DateTime.now();
      DateTime? endDate;
      
      if (map['createdAt'] != null && map['createdAt'] is Timestamp) {
        createdAt = (map['createdAt'] as Timestamp).toDate();
      }
      
      if (map['updatedAt'] != null && map['updatedAt'] is Timestamp) {
        updatedAt = (map['updatedAt'] as Timestamp).toDate();
      }
      
      if (map['startDate'] != null && map['startDate'] is Timestamp) {
        startDate = (map['startDate'] as Timestamp).toDate();
      }
      
      if (map['endDate'] != null && map['endDate'] is Timestamp) {
        endDate = (map['endDate'] as Timestamp).toDate();
      }
      
      return SpecialModel(
        id: map['id'] ?? '',
        name: map['name'] ?? 'Unnamed Special',
        description: map['description'] ?? 'No description available',
        price: (map['price'] is num) ? map['price'].toDouble() : 0.0,
        relatedProductId: map['relatedProductId'],
        isActive: map['isActive'] ?? false,
        startDate: startDate,
        endDate: endDate,
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
    return SpecialModel(
      id: '',
      name: '',
      description: '',
      price: 0.0,
      relatedProductId: null,
      isActive: true,
      startDate: DateTime.now(),
      endDate: null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
} 