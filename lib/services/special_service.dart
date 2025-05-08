import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/specialModel.dart';
import '../models/productModel.dart';
import 'product_service.dart';

class SpecialService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionName = 'specials';
  final ProductService _productService = ProductService();

  // Get all specials
  Future<List<SpecialModel>> getAllSpecials() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(collectionName)
          .orderBy('endDate', descending: true)
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

  // Get active specials (for home page)
  Future<List<SpecialModel>> getActiveSpecials() async {
    try {
      // Get current date/time
      final now = DateTime.now();
      
      // Firestore has limitations with compound queries using inequality operators
      // We can't use multiple inequality operators on different fields
      // So we'll use a simpler query and filter the results in memory
      
      QuerySnapshot querySnapshot = await _firestore
          .collection(collectionName)
          .where('isActive', isEqualTo: true)
          .get();

      final activeSpecials = querySnapshot.docs
          .map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            data['id'] = doc.id;
            return SpecialModel.fromMap(data);
          })
          .where((special) => 
            // Filter for current specials (between start and end date)
            special.startDate.isBefore(now) && 
            special.endDate.isAfter(now)
          )
          .toList();
      
      // Sort by start date
      activeSpecials.sort((a, b) => a.startDate.compareTo(b.startDate));
      
      return activeSpecials;
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
        // Ensure the document ID is included in the data
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

  // Get product details for a special
  Future<ProductModel?> getProductForSpecial(String? productId) async {
    if (productId == null || productId.isEmpty) {
      return null;
    }
    
    return await _productService.getProductById(productId);
  }
} 