class OrderModel {
  final String id;
  final String coffeeName;
  final String size;
  final String? addOn;
  final int quantity;
  final double basePrice;
  final double totalPrice;
  final String imagePath;
  final DateTime orderDate;
  final String status;
  final String userId;

  OrderModel({
    required this.id,
    required this.coffeeName,
    required this.size,
    this.addOn,
    required this.quantity,
    required this.basePrice,
    required this.totalPrice,
    required this.imagePath,
    required this.orderDate,
    this.status = 'Pending',
    required this.userId,
  });

  // Create a copy of the order with updated properties
  OrderModel copyWith({
    String? id,
    String? coffeeName,
    String? size,
    String? addOn,
    int? quantity,
    double? basePrice,
    double? totalPrice,
    String? imagePath,
    DateTime? orderDate,
    String? status,
    String? userId,
  }) {
    return OrderModel(
      id: id ?? this.id,
      coffeeName: coffeeName ?? this.coffeeName,
      size: size ?? this.size,
      addOn: addOn ?? this.addOn,
      quantity: quantity ?? this.quantity,
      basePrice: basePrice ?? this.basePrice,
      totalPrice: totalPrice ?? this.totalPrice,
      imagePath: imagePath ?? this.imagePath,
      orderDate: orderDate ?? this.orderDate,
      status: status ?? this.status,
      userId: userId ?? this.userId,
    );
  }

  // Convert OrderModel to Map for Firestore
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
      'orderDate': orderDate.millisecondsSinceEpoch,
      'status': status,
      'userId': userId,
    };
  }

  // Create OrderModel from Firestore Map
  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'],
      coffeeName: map['coffeeName'],
      size: map['size'],
      addOn: map['addOn'],
      quantity: map['quantity'],
      basePrice: map['basePrice'],
      totalPrice: map['totalPrice'],
      imagePath: map['imagePath'],
      orderDate: DateTime.fromMillisecondsSinceEpoch(map['orderDate']),
      status: map['status'] ?? 'Pending',
      userId: map['userId'] ?? '',
    );
  }
} 