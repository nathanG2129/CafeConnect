import '../models/specialModel.dart';
import '../models/productModel.dart';
import 'special_service.dart';

class DiscountService {
  final SpecialService _specialService = SpecialService();
  
  // Cached active specials
  List<SpecialModel>? _activeSpecials;
  DateTime? _lastFetchTime;
  
  // Maximum age of cached specials (5 minutes)
  static const Duration _cacheMaxAge = Duration(minutes: 5);
  
  // Get all active specials (with caching)
  Future<List<SpecialModel>> getActiveSpecials() async {
    final now = DateTime.now();
    
    // If we have cached specials that are still valid, return them
    if (_activeSpecials != null && 
        _lastFetchTime != null &&
        now.difference(_lastFetchTime!) < _cacheMaxAge) {
      return _activeSpecials!;
    }
    
    // Otherwise, fetch fresh data
    final activeSpecials = await _specialService.getActiveSpecials();
    
    // Update the cache
    _activeSpecials = activeSpecials;
    _lastFetchTime = now;
    
    return activeSpecials;
  }
  
  // Clear the cache (useful when adding new specials)
  void clearCache() {
    _activeSpecials = null;
    _lastFetchTime = null;
  }
  
  // Check if a product has an applicable special
  Future<SpecialModel?> findSpecialForProduct(String productId) async {
    final activeSpecials = await getActiveSpecials();
    
    // Look for specials that apply to this product
    try {
      return activeSpecials.firstWhere(
        (special) => special.productId == productId
      );
    } catch (e) {
      // No matching special found
      return null;
    }
  }
  
  // Calculate discounted price for a product
  Future<Map<String, dynamic>> calculateDiscountedPrice(ProductModel product) async {
    final special = await findSpecialForProduct(product.id);
    
    if (special == null) {
      // No applicable special found, return original price
      return {
        'originalPrice': product.basePrice,
        'finalPrice': product.basePrice,
        'special': null,
        'hasDiscount': false,
      };
    }
    
    // Apply the special
    return {
      'originalPrice': product.basePrice,
      'finalPrice': special.price,
      'special': special,
      'hasDiscount': true,
    };
  }
} 