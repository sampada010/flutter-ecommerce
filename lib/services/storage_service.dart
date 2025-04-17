import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecommerce_app/models/product.dart';
import 'package:ecommerce_app/models/cart_item.dart';

class StorageService {
  static const String _localProductsKey = 'local_products';
  static const String _cartItemsKey = 'cart_items';
  
  // Local Products Management
  Future<List<Product>> getLocalProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final String? productsJson = prefs.getString(_localProductsKey);
    
    if (productsJson == null) {
      return [];
    }
    
    List<dynamic> productsList = json.decode(productsJson);
    return productsList.map((item) => Product.fromJson(item)).toList();
  }
  
  Future<void> saveLocalProducts(List<Product> products) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> productsJson = 
        products.map((product) => product.toJson()).toList();
    await prefs.setString(_localProductsKey, json.encode(productsJson));
  }
  
  Future<Product> addLocalProduct(Product product) async {
    final localProducts = await getLocalProducts();
    
    // Generate a unique ID (negative to avoid conflicts with API products)
    final newId = localProducts.isEmpty 
        ? -1 
        : localProducts
            .map((p) => p.id)
            .reduce((min, id) => id < min ? id : min) - 1;
    
    final newProduct = product.copyWith(
      id: newId,
      isLocallyAdded: true,
    );
    
    localProducts.add(newProduct);
    await saveLocalProducts(localProducts);
    return newProduct;
  }
  
  Future<Product> updateLocalProduct(Product product) async {
    final localProducts = await getLocalProducts();
    
    final index = localProducts.indexWhere((p) => p.id == product.id);
    if (index >= 0) {
      localProducts[index] = product;
      await saveLocalProducts(localProducts);
      return product;
    } else {
      throw Exception('Product not found');
    }
  }
  
  Future<void> deleteLocalProduct(int id) async {
    final localProducts = await getLocalProducts();
    
    final filteredProducts = localProducts.where((p) => p.id != id).toList();
    await saveLocalProducts(filteredProducts);
  }
  
  // Cart Management
  Future<List<CartItem>> getCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final String? cartJson = prefs.getString(_cartItemsKey);
    
    if (cartJson == null) {
      return [];
    }
    
    List<dynamic> cartList = json.decode(cartJson);
    return cartList.map((item) => CartItem.fromJson(item)).toList();
  }
  
  Future<void> saveCartItems(List<CartItem> cartItems) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> cartItemsJson = 
        cartItems.map((item) => item.toJson()).toList();
    await prefs.setString(_cartItemsKey, json.encode(cartItemsJson));
  }
  
  Future<void> addToCart(Product product, [int quantity = 1]) async {
    final cartItems = await getCartItems();
    
    final existingIndex = cartItems.indexWhere(
      (item) => item.product.id == product.id
    );
    
    if (existingIndex >= 0) {
      cartItems[existingIndex].quantity += quantity;
    } else {
      cartItems.add(CartItem(product: product, quantity: quantity));
    }
    
    await saveCartItems(cartItems);
  }
  
  Future<void> updateCartItemQuantity(int productId, int quantity) async {
    final cartItems = await getCartItems();
    
    final existingIndex = cartItems.indexWhere(
      (item) => item.product.id == productId
    );
    
    if (existingIndex >= 0) {
      if (quantity > 0) {
        cartItems[existingIndex].quantity = quantity;
      } else {
        cartItems.removeAt(existingIndex);
      }
      await saveCartItems(cartItems);
    }
  }
  
  Future<void> removeFromCart(int productId) async {
    final cartItems = await getCartItems();
    
    final filteredItems = cartItems.where(
      (item) => item.product.id != productId
    ).toList();
    
    await saveCartItems(filteredItems);
  }
  
  Future<void> clearCart() async {
    await saveCartItems([]);
  }
}
