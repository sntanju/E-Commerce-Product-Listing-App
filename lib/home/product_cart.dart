import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {

  final dynamic product;
  final int index;
  const ProductCard({super.key, required this.product, required this.index});

  @override
  Widget build(BuildContext context) {
    final price = product['price'];
    final discount = product['discountPercentage'];
    final rating = product['rating'];
    final thumbnail = product['thumbnail'];
    final title = product['title'];
    final stock = product['stock'];
    final originalPrice = (price / (1 - discount / 100)).round();
    final bool isFavorited = index % 2 == 0; 

    return Container(
      
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container( 
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300, 
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    thumbnail,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                    },
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                  ),
                ),
              ),
              
              Positioned(
                top: 5,
                right: 5,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white, 
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(6),
                  child: Icon(
                    isFavorited ? Icons.favorite : Icons.favorite_border,
                    color: isFavorited ? Colors.red : Colors.grey,
                    size: 20,
                  ),

                ),
              ),

              if (stock <= 0)
                Positioned(
                  top: 5,
                  left: 5,
                  child: Container(
                    color: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    child: const Text(
                      "Out of Stock",
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(title, maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),

          Row(
            mainAxisAlignment: MainAxisAlignment.start, 
            crossAxisAlignment: CrossAxisAlignment.center, 
            children: [
              Text(
                '\$$price',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 5), 
              Text(
                '\$$originalPrice',
                style: const TextStyle(
                  color: Colors.grey,
                  decoration: TextDecoration.lineThrough,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 5), 
              Text(
                '$discount% OFF',
                style: const TextStyle(
                  color: Colors.orange,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 16),
              Text('$rating, ($stock)', style: const TextStyle(fontSize: 12), ),
            ],
          )
        ],
      ),
    );
  }
}

