import 'package:flutter_activity1/models/orderItemModel.dart';

class OrderModel {
  final String id;
  final List<OrderItemModel> items;
  final DateTime orderDate;
  final String status;
  final String userId;
  final double subtotal;
  final double tax;
  final double totalAmount;

  OrderModel({
    required this.id,
    required this.items,
    required this.orderDate,
    this.status = 'Pending',
    required this.userId,
    required this.subtotal,
    required this.tax,
    required this.totalAmount,
  });

  // Create a copy of the order with updated properties
  OrderModel copyWith({
    String? id,
    List<OrderItemModel>? items,
    DateTime? orderDate,
    String? status,
    String? userId,
    double? subtotal,
    double? tax,
    double? totalAmount,
  }) {
    return OrderModel(
      id: id ?? this.id,
      items: items ?? this.items,
      orderDate: orderDate ?? this.orderDate,
      status: status ?? this.status,
      userId: userId ?? this.userId,
      subtotal: subtotal ?? this.subtotal,
      tax: tax ?? this.tax,
      totalAmount: totalAmount ?? this.totalAmount,
    );
  }

  // Convert OrderModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'items': items.map((item) => item.toMap()).toList(),
      'orderDate': orderDate.millisecondsSinceEpoch,
      'status': status,
      'userId': userId,
      'subtotal': subtotal,
      'tax': tax,
      'totalAmount': totalAmount,
    };
  }

  // Create OrderModel from Firestore Map
  factory OrderModel.fromMap(Map<String, dynamic> map) {
    List<OrderItemModel> orderItems = [];
    if (map['items'] != null) {
      orderItems = List<OrderItemModel>.from(
        (map['items'] as List).map((item) => OrderItemModel.fromMap(item))
      );
    }

    return OrderModel(
      id: map['id'],
      items: orderItems,
      orderDate: DateTime.fromMillisecondsSinceEpoch(map['orderDate']),
      status: map['status'] ?? 'Pending',
      userId: map['userId'] ?? '',
      subtotal: map['subtotal'] ?? 0.0,
      tax: map['tax'] ?? 0.0,
      totalAmount: map['totalAmount'] ?? 0.0,
    );
  }

  // Factory constructor to create a new order from cart items
  factory OrderModel.fromCartItems({
    required String id,
    required List<OrderItemModel> items,
    required String userId,
    double taxRate = 0.08,
  }) {
    final subtotal = items.fold<double>(
      0,
      (sum, item) => sum + item.totalPrice,
    );
    
    final tax = subtotal * taxRate;
    
    final totalAmount = subtotal + tax;
    
    return OrderModel(
      id: id,
      items: items,
      orderDate: DateTime.now(),
      status: 'Pending',
      userId: userId,
      subtotal: subtotal,
      tax: tax,
      totalAmount: totalAmount,
    );
  }
} 