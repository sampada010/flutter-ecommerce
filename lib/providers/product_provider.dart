
import 'package:flutter/foundation.dart';
import 'package:ecommerce_app/models/product.dart';
import 'package:ecommerce_app/services/api_service.dart';
import 'package:ecommerce_app/services/storage_service.dart';

class ProductProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();
  
  List<Product> _products = [];
  List<Product> _localProducts = [];
  bool _isLoading = false;
  String _error = '';
  
  // Getters
  List<Product> get allProducts => [..._products, ..._localProducts];
  List<Product> get apiProducts => _products;
  List<Product> get localProducts => _localProducts;
  bool get isLoading => _isLoading;
  String get error => _error;
  
  // Fetch all products from the API
  Future<void> fetchProducts() async {
    _setLoading(true);
    _clearError();
    
    try {
      _products = await _apiService.fetchProducts();
      _localProducts = await _storageService.getLocalProducts();
      notifyListeners();
    } catch (e) {
      _setError('Failed to fetch products: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  // Get a product by ID (from either API or local products)
  Product? getProductById(int id) {
    final apiProduct = _products.where((p) => p.id == id).toList();
    if (apiProduct.isNotEmpty) {
      return apiProduct.first;
    }
    
    final localProduct = _localProducts.where((p) => p.id == id).toList();
    if (localProduct.isNotEmpty) {
      return localProduct.first;
    }
    
    return null;
  }
  
  // Add a new product locally
  Future<void> addLocalProduct(Product product) async {
    _setLoading(true);
    _clearError();
    
    try {
      final newProduct = await _storageService.addLocalProduct(product);
      _localProducts.add(newProduct);
      notifyListeners();
    } catch (e) {
      _setError('Failed to add product: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  // Update a local product
  Future<void> updateLocalProduct(Product product) async {
    _setLoading(true);
    _clearError();
    
    try {
      final updatedProduct = await _storageService.updateLocalProduct(product);
      
      final index = _localProducts.indexWhere((p) => p.id == product.id);
      if (index >= 0) {
        _localProducts[index] = updatedProduct;
        notifyListeners();
      } else {
        _setError('Product not found');
      }
    } catch (e) {
      _setError('Failed to update product: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  // Delete a local product
  Future<void> deleteLocalProduct(int id) async {
    _setLoading(true);
    _clearError();
    
    try {
      await _storageService.deleteLocalProduct(id);
      
      _localProducts.removeWhere((p) => p.id == id);
      notifyListeners();
    } catch (e) {
      _setError('Failed to delete product: $e');
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
