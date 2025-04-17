
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce_app/models/product.dart';
import 'package:ecommerce_app/providers/product_provider.dart';
import 'package:ecommerce_app/widgets/product_form.dart';

class ProductFormScreen extends StatelessWidget {
  final Product? product;
  
  const ProductFormScreen({
    Key? key,
    this.product,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final isEditing = product != null;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Product' : 'Add Product'),
      ),
      body: ProductForm(
        initialProduct: product,
        onSave: (updatedProduct) {
          final productProvider = 
              Provider.of<ProductProvider>(context, listen: false);
          
          if (isEditing) {
            productProvider.updateLocalProduct(updatedProduct).then((_) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Product updated successfully'),
                  duration: Duration(seconds: 2),
                ),
              );
            });
          } else {
            productProvider.addLocalProduct(updatedProduct).then((_) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Product added successfully'),
                  duration: Duration(seconds: 2),
                ),
              );
            });
          }
        },
      ),
    );
  }
}