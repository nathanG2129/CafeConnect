import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_activity1/models/productModel.dart';

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
        // Ensure the document ID is included in the data
        data['id'] = doc.id;
        return ProductModel.fromMap(data);
      }).toList();
    } catch (e) {
      // Log the error for debugging
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
        // Ensure the document ID is included in the data
        data['id'] = doc.id;
        return ProductModel.fromMap(data);
      }).toList();
    } catch (e) {
      // Log the error for debugging
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
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        // Ensure the document ID is included in the data
        data['id'] = doc.id;
        return ProductModel.fromMap(data);
      }
      return null;
    } catch (e) {
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
      return false;
    }
  }
} 