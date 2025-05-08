import 'package:cloud_firestore/cloud_firestore.dart';

class PromotionModel {
  final String id;
  final String title;
  final String time; // e.g., "2 PM - 5 PM" or "All Day"
  final String description;
  final bool isActive;
  final DateTime startDate;
  final DateTime? endDate; // Optional
  final DateTime createdAt;
  final DateTime updatedAt;

  PromotionModel({
    required this.id,
    required this.title,
    required this.time,
    required this.description,
    required this.isActive,
    required this.startDate,
    this.endDate,
    required this.createdAt,
    required this.updatedAt,
  });

  // Create a copy of the promotion with updated properties
  PromotionModel copyWith({
    String? id,
    String? title,
    String? time,
    String? description,
    bool? isActive,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PromotionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      time: time ?? this.time,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Convert PromotionModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'time': time,
      'description': description,
      'isActive': isActive,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': endDate != null ? Timestamp.fromDate(endDate!) : null,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // Create PromotionModel from Firestore Map
  factory PromotionModel.fromMap(Map<String, dynamic> map) {
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
      
      return PromotionModel(
        id: map['id'] ?? '',
        title: map['title'] ?? 'Unnamed Promotion',
        time: map['time'] ?? 'All Day',
        description: map['description'] ?? 'No description available',
        isActive: map['isActive'] ?? false,
        startDate: startDate,
        endDate: endDate,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
    } catch (e) {
      // Return a default promotion on error
      return PromotionModel.empty().copyWith(
        id: map['id'] ?? '',
        title: map['title'] ?? 'Error Loading Promotion',
      );
    }
  }

  // Create an empty promotion with default values
  factory PromotionModel.empty() {
    return PromotionModel(
      id: '',
      title: '',
      time: 'All Day',
      description: '',
      isActive: true,
      startDate: DateTime.now(),
      endDate: null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
} 