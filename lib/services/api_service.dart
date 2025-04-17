
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ecommerce_app/models/product.dart';

class ApiService {
  final String baseUrl = 'https://fakestoreapi.com';

  Future<List<Product>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/products'));
      
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }

  Future<Product> fetchProduct(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/products/$id'));
      
      if (response.statusCode == 200) {
        return Product.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load product: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch product: $e');
    }
  }

  // Note: These operations are simulated locally and don't actually
  // persist data to the API in this demo app
  Future<Product> createProduct(Product product) async {
    // In a real app, you would POST to the API here
    // For this demo, we'll just return the product with a new ID
    return product;
  }

  Future<Product> updateProduct(Product product) async {
    // In a real app, you would PUT to the API here
    // For this demo, we'll just return the updated product
    return product;
  }

  Future<void> deleteProduct(int id) async {
    // In a real app, you would DELETE from the API here
    // For this demo, we'll just return a success response
    return;
  }
}