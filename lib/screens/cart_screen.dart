
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce_app/providers/cart_provider.dart';
import 'package:ecommerce_app/widgets/app_scaffold.dart';
import 'package:ecommerce_app/widgets/cart_item_tile.dart';
import 'package:ecommerce_app/widgets/empty_state.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart';
  
  const CartScreen({Key? key}) : super(key: key);
  
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isInit = false;
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    if (!_isInit) {
      _loadCart();
      _isInit = true;
    }
  }
  
  Future<void> _loadCart() async {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    await cartProvider.loadCart();
  }
  
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.items;
    final isLoading = cartProvider.isLoading;
    
    return AppScaffold(
      title: 'Shopping Cart',
      actions: cartItems.isNotEmpty
          ? [
              IconButton(
                icon: const Icon(Icons.delete_sweep),
                tooltip: 'Clear Cart',
                onPressed: () => _showClearCartConfirmation(context),
              ),
            ]
          : null,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : cartItems.isEmpty
              ? EmptyState(
                  icon: Icons.shopping_cart_outlined,
                  title: 'Your Cart is Empty',
                  message: 'Looks like you haven\'t added any products to your cart yet.',
                  buttonText: 'Start Shopping',
                  onButtonPressed: () => 
                      Navigator.of(context).pushReplacementNamed('/'),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.only(
                          top: 8,
                          left: 8,
                          right: 8, 
                          bottom: 100,
                        ),
                        itemCount: cartItems.length,
                        itemBuilder: (ctx, i) => CartItemTile(
                          item: cartItems[i],
                          onQuantityChanged: (quantity) => 
                              cartProvider.updateQuantity(
                                  cartItems[i].product.id, quantity),
                          onRemove: () => 
                              cartProvider.removeFromCart(cartItems[i].product.id),
                        ),
                      ),
                    ),
                  ],
                ),
      floatingActionButton: cartItems.isEmpty
          ? null
          : Container(
              width: double.infinity,
              margin: const EdgeInsets.only(left: 32),
              child: FloatingActionButton.extended(
                onPressed: () => _showCheckoutDialog(context),
                backgroundColor: Theme.of(context).colorScheme.primary,
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Checkout',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '\$${cartProvider.totalAmount.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
  
  void _showClearCartConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear Cart'),
        content: const Text(
          'Are you sure you want to remove all items from your cart?'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              final cartProvider = 
                  Provider.of<CartProvider>(context, listen: false);
              cartProvider.clearCart();
              Navigator.of(context).pop();
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cart cleared'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('CLEAR'),
          ),
        ],
      ),
    );
  }
  
  void _showCheckoutDialog(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Checkout'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'This is a demo app, so we won\'t process any real payments.',
            ),
            const SizedBox(height: 16),
            Text(
              'Total Amount: \$${cartProvider.totalAmount.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () {
              cartProvider.clearCart();
              Navigator.of(context).pop();
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Order placed successfully!'),
                  duration: Duration(seconds: 3),
                ),
              );
            },
            child: const Text('PLACE ORDER'),
          ),
        ],
      ),
    );
  }
}