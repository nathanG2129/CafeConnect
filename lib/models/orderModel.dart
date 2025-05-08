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
  final String? coffeeName;
  final String? size;
  final String? addOn;
  final int? quantity;
  final double? basePrice;
  final double? totalPrice;
  final String? imagePath;

  OrderModel({
    required this.id,
    required this.items,
    required this.orderDate,
    this.status = 'Pending',
    required this.userId,
    required this.subtotal,
    required this.tax,
    required this.totalAmount,
    this.coffeeName,
    this.size,
    this.addOn,
    this.quantity,
    this.basePrice,
    this.totalPrice,
    this.imagePath,
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
    String? coffeeName,
    String? size,
    String? addOn,
    int? quantity,
    double? basePrice,
    double? totalPrice,
    String? imagePath,
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
      coffeeName: coffeeName ?? this.coffeeName,
      size: size ?? this.size,
      addOn: addOn ?? this.addOn,
      quantity: quantity ?? this.quantity,
      basePrice: basePrice ?? this.basePrice,
      totalPrice: totalPrice ?? this.totalPrice,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  // Convert OrderModel to Map for Firestore
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {
      'id': id,
      'items': items.map((item) => item.toMap()).toList(),
      'orderDate': orderDate.millisecondsSinceEpoch,
      'status': status,
      'userId': userId,
      'subtotal': subtotal,
      'tax': tax,
      'totalAmount': totalAmount,
      'isMultiItemOrder': true,
    };

    if (items.length == 1 && coffeeName != null) {
      map['coffeeName'] = coffeeName;
      map['size'] = size;
      map['addOn'] = addOn;
      map['quantity'] = quantity;
      map['basePrice'] = basePrice;
      map['totalPrice'] = totalPrice;
      map['imagePath'] = imagePath;
    }

    return map;
  }

  // Create OrderModel from Firestore Map
  factory OrderModel.fromMap(Map<String, dynamic> map) {
    final bool isMultiItemOrder = map['isMultiItemOrder'] == true;

    if (isMultiItemOrder) {
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
    } else {
      final orderItem = OrderItemModel(
        id: map['id'] ?? '',
        coffeeName: map['coffeeName'] ?? '',
        size: map['size'] ?? '',
        addOn: map['addOn'],
        quantity: map['quantity'] ?? 1,
        basePrice: map['basePrice'] ?? 0.0,
        totalPrice: map['totalPrice'] ?? 0.0,
        imagePath: map['imagePath'] ?? '',
      );

      return OrderModel(
        id: map['id'],
        items: [orderItem],
        orderDate: DateTime.fromMillisecondsSinceEpoch(map['orderDate']),
        status: map['status'] ?? 'Pending',
        userId: map['userId'] ?? '',
        subtotal: map['totalPrice'] ?? 0.0,
        tax: (map['totalPrice'] ?? 0.0) * 0.08,
        totalAmount: (map['totalPrice'] ?? 0.0) * 1.08,
        coffeeName: map['coffeeName'],
        size: map['size'],
        addOn: map['addOn'],
        quantity: map['quantity'],
        basePrice: map['basePrice'],
        totalPrice: map['totalPrice'],
        imagePath: map['imagePath'],
      );
    }
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