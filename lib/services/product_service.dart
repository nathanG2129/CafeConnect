import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_activity1/models/product_model.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionName = 'products';

  // Get all products
  Future<List<ProductModel>> getAllProducts() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(collectionName)
          .orderBy('name')
          .get();

      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return ProductModel.fromMap(data);
      }).toList();
    } catch (e) {
      print('Error getting products: ${e.toString()}');
      return [];
    }
  }

  // Get available products
  Future<List<ProductModel>> getAvailableProducts() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(collectionName)
          .where('isAvailable', isEqualTo: true)
          .orderBy('name')
          .get();

      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return ProductModel.fromMap(data);
      }).toList();
    } catch (e) {
      print('Error getting available products: ${e.toString()}');
      return [];
    }
  }

  // Get product by ID
  Future<ProductModel?> getProductById(String productId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection(collectionName)
          .doc(productId)
          .get();

      if (doc.exists) {
        return ProductModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting product: ${e.toString()}');
      return null;
    }
  }

  // Add a new product
  Future<bool> addProduct(ProductModel product) async {
    try {
      // Create a document reference with auto-generated ID if product.id is empty
      DocumentReference docRef = product.id.isEmpty
          ? _firestore.collection(collectionName).doc()
          : _firestore.collection(collectionName).doc(product.id);

      // Create a product with the generated ID
      ProductModel newProduct = product.copyWith(
        id: docRef.id,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Save to Firestore
      await docRef.set(newProduct.toMap());
      return true;
    } catch (e) {
      print('Error adding product: ${e.toString()}');
      return false;
    }
  }

  // Update an existing product
  Future<bool> updateProduct(ProductModel product) async {
    try {
      if (product.id.isEmpty) {
        return false; // Cannot update a product without an ID
      }

      // Update the product with the current timestamp
      ProductModel updatedProduct = product.copyWith(
        updatedAt: DateTime.now(),
      );

      // Update in Firestore
      await _firestore
          .collection(collectionName)
          .doc(product.id)
          .update(updatedProduct.toMap());
      return true;
    } catch (e) {
      print('Error updating product: ${e.toString()}');
      return false;
    }
  }

  // Toggle product availability
  Future<bool> toggleProductAvailability(String productId, bool isAvailable) async {
    try {
      await _firestore
          .collection(collectionName)
          .doc(productId)
          .update({
        'isAvailable': isAvailable,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
      return true;
    } catch (e) {
      print('Error toggling product availability: ${e.toString()}');
      return false;
    }
  }

  // Delete a product
  Future<bool> deleteProduct(String productId) async {
    try {
      await _firestore
          .collection(collectionName)
          .doc(productId)
          .delete();
      return true;
    } catch (e) {
      print('Error deleting product: ${e.toString()}');
      return false;
    }
  }
} 