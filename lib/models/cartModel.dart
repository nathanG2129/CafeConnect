import 'dart:convert';
import 'package:flutter_activity1/models/orderModel.dart';
import 'package:get_storage/get_storage.dart';

class CartModel {
  List<OrderModel> items = [];
  
  // Get total price of all items in cart
  double get totalPrice {
    return items.fold(0, (sum, item) => sum + item.totalPrice);
  }
  
  // Get total number of items in cart
  int get itemCount {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }
  
  // Add item to cart
  void addItem(OrderModel item) {
    // Check if the item already exists with the same coffee, size, and add-on
    int existingIndex = items.indexWhere((element) => 
      element.coffeeName == item.coffeeName && 
      element.size == item.size && 
      element.addOn == item.addOn
    );
    
    if (existingIndex != -1) {
      // Update the existing item quantity
      OrderModel existingItem = items[existingIndex];
      int newQuantity = existingItem.quantity + item.quantity;
      double newTotalPrice = existingItem.basePrice * newQuantity;
      
      items[existingIndex] = existingItem.copyWith(
        quantity: newQuantity,
        totalPrice: newTotalPrice,
      );
    } else {
      // Add as a new item
      items.add(item);
    }
    
    // Save to local storage
    _saveToStorage();
  }
  
  // Remove item from cart
  void removeItem(String itemId) {
    items.removeWhere((item) => item.id == itemId);
    _saveToStorage();
  }
  
  // Update item quantity
  void updateItemQuantity(String itemId, int newQuantity) {
    if (newQuantity <= 0) {
      removeItem(itemId);
      return;
    }
    
    int index = items.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      OrderModel item = items[index];
      double newTotalPrice = item.basePrice * newQuantity;
      
      items[index] = item.copyWith(
        quantity: newQuantity,
        totalPrice: newTotalPrice,
      );
      
      _saveToStorage();
    }
  }
  
  // Clear all items from cart
  void clearCart() {
    items.clear();
    _saveToStorage();
  }
  
  // Save cart items to local storage
  void _saveToStorage() {
    final storage = GetStorage();
    List<Map<String, dynamic>> itemsMap = items.map((item) => item.toMap()).toList();
    storage.write('cart_items', jsonEncode(itemsMap));
  }
  
  // Load cart items from local storage
  void loadFromStorage() {
    final storage = GetStorage();
    String? cartData = storage.read('cart_items');
    
    if (cartData != null) {
      final List<dynamic> decoded = jsonDecode(cartData);
      items = decoded.map((item) => OrderModel.fromMap(item)).toList();
    }
  }
} 