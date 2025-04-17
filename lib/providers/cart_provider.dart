
import 'package:flutter/foundation.dart';
import 'package:ecommerce_app/models/product.dart';
import 'package:ecommerce_app/models/cart_item.dart';
import 'package:ecommerce_app/services/storage_service.dart';

class CartProvider with ChangeNotifier {
  final StorageService _storageService = StorageService();
  
  List<CartItem> _items = [];
  bool _isLoading = false;
  String _error = '';
  
  // Getters
  List<CartItem> get items => _items;
  bool get isLoading => _isLoading;
  String get error => _error;
  
  // Calculate cart total
  double get totalAmount {
    return _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }
  
  // Calculate total quantity of items in cart
  int get itemCount {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }
  
  // Load cart items from storage
  Future<void> loadCart() async {
    _setLoading(true);
    _clearError();
    
    try {
      _items = await _storageService.getCartItems();
      notifyListeners();
    } catch (e) {
      _setError('Failed to load cart: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  // Add item to cart
  Future<void> addToCart(Product product, [int quantity = 1]) async {
    _setLoading(true);
    _clearError();
    
    try {
      await _storageService.addToCart(product, quantity);
      await loadCart(); // Reload cart from storage
    } catch (e) {
      _setError('Failed to add item to cart: $e');
      _setLoading(false);
    }
  }
  
  // Update cart item quantity
  Future<void> updateQuantity(int productId, int quantity) async {
    _setLoading(true);
    _clearError();
    
    try {
      await _storageService.updateCartItemQuantity(productId, quantity);
      await loadCart(); // Reload cart from storage
    } catch (e) {
      _setError('Failed to update cart: $e');
      _setLoading(false);
    }
  }
  
  // Remove item from cart
  Future<void> removeFromCart(int productId) async {
    _setLoading(true);
    _clearError();
    
    try {
      await _storageService.removeFromCart(productId);
      await loadCart(); // Reload cart from storage
    } catch (e) {
      _setError('Failed to remove item from cart: $e');
      _setLoading(false);
    }
  }
  
  // Clear the entire cart
  Future<void> clearCart() async {
    _setLoading(true);
    _clearError();
    
    try {
      await _storageService.clearCart();
      _items = [];
      notifyListeners();
    } catch (e) {
      _setError('Failed to clear cart: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  void _setError(String error) {
    _error = error;
    notifyListeners();
  }
  
  void _clearError() {
    _error = '';
    notifyListeners();
  }
}
