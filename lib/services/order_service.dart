import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_activity1/models/orderModel.dart';

class OrderService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Save order to Firestore
  Future<bool> saveOrder(OrderModel order) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        return false; // User not logged in
      }

      // Create new order with current user ID
      final updatedOrder = order.copyWith(userId: currentUser.uid);

      // Add order to the orders collection under the user's document
      await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('orders')
          .doc(order.id)
          .set(updatedOrder.toMap());

      // Also add to the global orders collection for staff access
      await _firestore
          .collection('orders')
          .doc(order.id)
          .set(updatedOrder.toMap());

      return true;
    } catch (e) {
      // print('Error saving order: ${e.toString()}');
      return false;
    }
  }

  // Get all orders for the current user
  Future<List<OrderModel>> getUserOrders() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        return []; // User not logged in
      }

      // Get orders from the orders subcollection
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('orders')
          .orderBy('orderDate', descending: true)
          .get();

      // Convert QuerySnapshot to List<OrderModel>
      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return OrderModel.fromMap(data);
      }).toList();
    } catch (e) {
      // print('Error getting orders: ${e.toString()}');
      return [];
    }
  }

  // Delete an order
  Future<bool> deleteOrder(String orderId) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        return false; // User not logged in
      }

      // Delete the order document from user's collection
      await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('orders')
          .doc(orderId)
          .delete();

      // Delete from global orders collection
      await _firestore
          .collection('orders')
          .doc(orderId)
          .delete();

      return true;
    } catch (e) {
      // print('Error deleting order: ${e.toString()}');
      return false;
    }
  }

  // STAFF METHODS

  // Get all orders for staff to manage
  Future<List<OrderModel>> getAllOrders() async {
    try {
      // Staff can access all orders
      QuerySnapshot querySnapshot = await _firestore
          .collection('orders')
          .orderBy('orderDate', descending: true)
          .get();

      // Convert QuerySnapshot to List<OrderModel>
      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return OrderModel.fromMap(data);
      }).toList();
    } catch (e) {
      // print('Error getting all orders: ${e.toString()}');
      return [];
    }
  }

  // Get orders with specific status
  Future<List<OrderModel>> getOrdersByStatus(String status) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('orders')
          .where('status', isEqualTo: status)
          .orderBy('orderDate', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return OrderModel.fromMap(data);
      }).toList();
    } catch (e) {
      // print('Error getting orders by status: ${e.toString()}');
      return [];
    }
  }

  // Update order status
  Future<bool> updateOrderStatus(String orderId, String newStatus) async {
    try {
      // Get the order first to preserve all fields
      DocumentSnapshot orderDoc = await _firestore
          .collection('orders')
          .doc(orderId)
          .get();

      if (!orderDoc.exists) {
        return false;
      }

      Map<String, dynamic> orderData = orderDoc.data() as Map<String, dynamic>;
      OrderModel order = OrderModel.fromMap(orderData);
      
      // Create updated order with new status
      OrderModel updatedOrder = order.copyWith(status: newStatus);
      
      // Update in global orders collection
      await _firestore
          .collection('orders')
          .doc(orderId)
          .update({'status': newStatus});
      
      // Also update in user's orders collection
      await _firestore
          .collection('users')
          .doc(order.userId)
          .collection('orders')
          .doc(orderId)
          .update({'status': newStatus});
      
      return true;
    } catch (e) {
      // print('Error updating order status: ${e.toString()}');
      return false;
    }
  }
} 