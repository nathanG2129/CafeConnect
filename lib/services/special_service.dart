import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_activity1/models/specialModel.dart';
import 'package:flutter_activity1/models/productModel.dart';
import 'package:flutter_activity1/services/product_service.dart';

class SpecialService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionName = 'specials';
  final ProductService _productService = ProductService();

  // Get all specials
  Future<List<SpecialModel>> getAllSpecials() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(collectionName)
          .orderBy('name')
          .get();

      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        // Ensure the document ID is included in the data
        data['id'] = doc.id;
        return SpecialModel.fromMap(data);
      }).toList();
    } catch (e) {
      return [];
    }
  }

  // Get active specials (isActive = true and within date range)
  Future<List<SpecialModel>> getActiveSpecials() async {
    try {
      DateTime now = DateTime.now();
      QuerySnapshot querySnapshot = await _firestore
          .collection(collectionName)
          .where('isActive', isEqualTo: true)
          .where('startDate', isLessThanOrEqualTo: Timestamp.fromDate(now))
          .get();

      List<SpecialModel> allSpecials = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return SpecialModel.fromMap(data);
      }).toList();

      // Filter by endDate (if endDate is null or after now)
      return allSpecials.where((special) {
        return special.endDate == null || special.endDate!.isAfter(now);
      }).toList();
    } catch (e) {
      return [];
    }
  }

  // Get special by ID
  Future<SpecialModel?> getSpecialById(String specialId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection(collectionName)
          .doc(specialId)
          .get();

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return SpecialModel.fromMap(data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Add a new special
  Future<bool> addSpecial(SpecialModel special) async {
    try {
      // Create a document reference with auto-generated ID if special.id is empty
      DocumentReference docRef = special.id.isEmpty
          ? _firestore.collection(collectionName).doc()
          : _firestore.collection(collectionName).doc(special.id);

      // Create a special with the generated ID
      SpecialModel newSpecial = special.copyWith(
        id: docRef.id,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Save to Firestore
      await docRef.set(newSpecial.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  // Update an existing special
  Future<bool> updateSpecial(SpecialModel special) async {
    try {
      if (special.id.isEmpty) {
        return false; // Cannot update a special without an ID
      }

      // Update the special with the current timestamp
      SpecialModel updatedSpecial = special.copyWith(
        updatedAt: DateTime.now(),
      );

      // Update in Firestore
      await _firestore
          .collection(collectionName)
          .doc(special.id)
          .update(updatedSpecial.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  // Toggle special active status
  Future<bool> toggleSpecialStatus(String specialId, bool isActive) async {
    try {
      await _firestore
          .collection(collectionName)
          .doc(specialId)
          .update({
        'isActive': isActive,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  // Delete a special
  Future<bool> deleteSpecial(String specialId) async {
    try {
      await _firestore
          .collection(collectionName)
          .doc(specialId)
          .delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  // Get product associated with a special
  Future<ProductModel?> getRelatedProduct(String? productId) async {
    if (productId == null || productId.isEmpty) {
      return null;
    }
    
    return await _productService.getProductById(productId);
  }
} 