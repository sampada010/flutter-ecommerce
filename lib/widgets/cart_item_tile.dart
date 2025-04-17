import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ecommerce_app/models/cart_item.dart';

class CartItemTile extends StatelessWidget {
  final CartItem item;
  final Function(int) onQuantityChanged;
  final VoidCallback onRemove;
  
  const CartItemTile({
    Key? key,
    required this.item,
    required this.onQuantityChanged,
    required this.onRemove,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => onRemove(),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Remove',
          ),
        ],
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              SizedBox(
                width: 80,
                height: 80,
                child: CachedNetworkImage(
                  imageUrl: item.product.image,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              const SizedBox(width: 12),
              
              // Product Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.product.title,
                      style: theme.textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    
                    Text(
                      '\$${item.product.price.toStringAsFixed(2)}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // Quantity Controls
                    Row(
                      children: [
                        _QuantityButton(
                          icon: Icons.remove,
                          onPressed: () {
                            if (item.quantity > 1) {
                              onQuantityChanged(item.quantity - 1);
                            } else {
                              onRemove();
                            }
                          },
                        ),
                        SizedBox(
                          width: 40,
                          child: Text(
                            '${item.quantity}',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.titleMedium,
                          ),
                        ),
                        _QuantityButton(
                          icon: Icons.add,
                          onPressed: () =>
                              onQuantityChanged(item.quantity + 1),
                        ),
                        const Spacer(),
                        
                        // Subtotal
                        Text(
                          '\$${(item.product.price * item.quantity).toStringAsFixed(2)}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  
  const _QuantityButton({
    Key? key,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(4),
      ),
      child: IconButton(
        icon: Icon(icon, size: 16),
        onPressed: onPressed,
        padding: EdgeInsets.zero,
      ),
    );
  }
}
