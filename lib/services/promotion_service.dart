import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_activity1/models/promotionModel.dart';

class PromotionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionName = 'promotions';

  // Get all promotions
  Future<List<PromotionModel>> getAllPromotions() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(collectionName)
          .orderBy('title')
          .get();

      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        // Ensure the document ID is included in the data
        data['id'] = doc.id;
        return PromotionModel.fromMap(data);
      }).toList();
    } catch (e) {
      return [];
    }
  }

  // Get active promotions (isActive = true and within date range)
  Future<List<PromotionModel>> getActivePromotions() async {
    try {
      DateTime now = DateTime.now();
      QuerySnapshot querySnapshot = await _firestore
          .collection(collectionName)
          .where('isActive', isEqualTo: true)
          .where('startDate', isLessThanOrEqualTo: Timestamp.fromDate(now))
          .get();

      List<PromotionModel> allPromotions = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return PromotionModel.fromMap(data);
      }).toList();

      // Filter by endDate (if endDate is null or after now)
      return allPromotions.where((promotion) {
        return promotion.endDate == null || promotion.endDate!.isAfter(now);
      }).toList();
    } catch (e) {
      return [];
    }
  }

  // Get promotion by ID
  Future<PromotionModel?> getPromotionById(String promotionId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection(collectionName)
          .doc(promotionId)
          .get();

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return PromotionModel.fromMap(data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Add a new promotion
  Future<bool> addPromotion(PromotionModel promotion) async {
    try {
      // Create a document reference with auto-generated ID if promotion.id is empty
      DocumentReference docRef = promotion.id.isEmpty
          ? _firestore.collection(collectionName).doc()
          : _firestore.collection(collectionName).doc(promotion.id);

      // Create a promotion with the generated ID
      PromotionModel newPromotion = promotion.copyWith(
        id: docRef.id,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Save to Firestore
      await docRef.set(newPromotion.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  // Update an existing promotion
  Future<bool> updatePromotion(PromotionModel promotion) async {
    try {
      if (promotion.id.isEmpty) {
        return false; // Cannot update a promotion without an ID
      }

      // Update the promotion with the current timestamp
      PromotionModel updatedPromotion = promotion.copyWith(
        updatedAt: DateTime.now(),
      );

      // Update in Firestore
      await _firestore
          .collection(collectionName)
          .doc(promotion.id)
          .update(updatedPromotion.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  // Toggle promotion active status
  Future<bool> togglePromotionStatus(String promotionId, bool isActive) async {
    try {
      await _firestore
          .collection(collectionName)
          .doc(promotionId)
          .update({
        'isActive': isActive,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  // Delete a promotion
  Future<bool> deletePromotion(String promotionId) async {
    try {
      await _firestore
          .collection(collectionName)
          .doc(promotionId)
          .delete();
      return true;
    } catch (e) {
      return false;
    }
  }
} 