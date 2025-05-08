import 'package:flutter/material.dart';
import '../models/specialModel.dart';
import '../models/productModel.dart';

class SpecialProductCard extends StatelessWidget {
  final SpecialModel special;
  final ProductModel product;
  final VoidCallback? onAddToCart;
  final VoidCallback? onViewDetails;

  const SpecialProductCard({
    Key? key,
    required this.special,
    required this.product,
    this.onAddToCart,
    this.onViewDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final discount = product.basePrice - special.price;
    final discountPercent = (discount / product.basePrice) * 100;
    final showDiscount = discount > 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Discount badge
          if (showDiscount)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red[700],
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
                child: Text(
                  '-${discountPercent.toStringAsFixed(0)}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          
          // Product image
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.asset(
                  product.imagePath,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 150,
                    width: double.infinity,
                    color: Colors.brown[100],
                    child: Icon(
                      Icons.coffee,
                      size: 50,
                      color: Colors.brown[300],
                    ),
                  ),
                ),
              ),
              
              // Discount badge positioned on image
              if (showDiscount)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red[700],
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                      ),
                    ),
                    child: Text(
                      '-${discountPercent.toStringAsFixed(0)}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          
          // Special information
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.star, size: 16, color: Colors.amber[700]),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        special.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  special.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Special Price: ₱${special.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700],
                          ),
                        ),
                        if (showDiscount)
                          Text(
                            'Regular: ₱${product.basePrice.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                      ],
                    ),
                    Row(
                      children: [
                        if (onViewDetails != null)
                          IconButton(
                            icon: const Icon(Icons.info_outline),
                            color: Colors.blue[700],
                            tooltip: 'View product details',
                            onPressed: onViewDetails,
                            constraints: const BoxConstraints(),
                            padding: const EdgeInsets.all(4),
                            iconSize: 20,
                          ),
                        const SizedBox(width: 4),
                        if (onAddToCart != null)
                          IconButton(
                            icon: const Icon(Icons.add_shopping_cart),
                            color: Colors.brown[700],
                            tooltip: 'Add to cart',
                            onPressed: onAddToCart,
                            constraints: const BoxConstraints(),
                            padding: const EdgeInsets.all(4),
                            iconSize: 20,
                          ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Based on: ${product.name}',
                  style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey[600],
                  ),
                ),
                
                // Limited time tag
                if (special.endDate != null)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.amber[100],
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.amber[300]!),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.access_time, size: 12, color: Colors.amber[800]),
                        const SizedBox(width: 4),
                        Text(
                          'Limited time offer',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber[800],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 