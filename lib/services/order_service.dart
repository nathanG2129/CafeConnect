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

      // Add order to the orders collection under the user's document
      await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('orders')
          .doc(order.id)
          .set(order.toMap());

      return true;
    } catch (e) {
      print('Error saving order: ${e.toString()}');
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
      print('Error getting orders: ${e.toString()}');
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

      // Delete the order document
      await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('orders')
          .doc(orderId)
          .delete();

      return true;
    } catch (e) {
      print('Error deleting order: ${e.toString()}');
      return false;
    }
  }
} 