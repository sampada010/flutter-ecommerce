
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce_app/models/product.dart';
import 'package:ecommerce_app/providers/cart_provider.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  
  const ProductCard({
    Key? key,
    required this.product,
    required this.onTap,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            AspectRatio(
              aspectRatio: 1,
              child: CachedNetworkImage(
                imageUrl: product.image,
                fit: BoxFit.contain,
                placeholder: (context, url) => Container(
                  color: Colors.grey[200],
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[200],
                  child: const Icon(Icons.error),
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  
                  // Category
                  Text(
                    product.category.toUpperCase(),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Price and Rating Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Price
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      
                      // Rating
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            size: 16,
                            color: Colors.amber,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            product.rating.rate.toStringAsFixed(1),
                            style: theme.textTheme.bodySmall,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '(${product.rating.count})',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Add to Cart Button
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.shopping_cart, size: 16),
                          label: const Text('Add'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 0,
                            ),
                          ),
                          onPressed: () {
                            final cartProvider = 
                                Provider.of<CartProvider>(
                                    context, 
                                    listen: false);
                            cartProvider.addToCart(product);
                            
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${product.title} added to cart',
                                ),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                        ),
                      ),
                      
                      // Edit & Delete Buttons (for locally added products)
                      if (product.isLocallyAdded) ...[
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.edit, size: 20),
                          onPressed: onEdit,
                          tooltip: 'Edit',
                          color: Colors.blue,
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, size: 20),
                          onPressed: onDelete,
                          tooltip: 'Delete',
                          color: Colors.red,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}