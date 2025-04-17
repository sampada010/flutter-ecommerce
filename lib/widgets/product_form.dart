
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ecommerce_app/models/product.dart';

class ProductForm extends StatefulWidget {
  final Product? initialProduct;
  final Function(Product) onSave;
  
  const ProductForm({
    Key? key,
    this.initialProduct,
    required this.onSave,
  }) : super(key: key);
  
  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _categoryController;
  late TextEditingController _imageUrlController;
  
  @override
  void initState() {
    super.initState();
    // Initialize controllers with initial values if editing
    _titleController = TextEditingController(
      text: widget.initialProduct?.title ?? ''
    );
    _descriptionController = TextEditingController(
      text: widget.initialProduct?.description ?? ''
    );
    _priceController = TextEditingController(
      text: widget.initialProduct?.price.toString() ?? ''
    );
    _categoryController = TextEditingController(
      text: widget.initialProduct?.category ?? ''
    );
    _imageUrlController = TextEditingController(
      text: widget.initialProduct?.image ?? 'https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg'
    );
  }
  
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }
  
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Create product from form values
      final product = Product(
        id: widget.initialProduct?.id ?? 0, // Will be replaced if adding new
        title: _titleController.text,
        description: _descriptionController.text,
        price: double.tryParse(_priceController.text) ?? 0.0,
        category: _categoryController.text,
        image: _imageUrlController.text,
        rating: widget.initialProduct?.rating ?? Rating(rate: 0, count: 0),
        isLocallyAdded: true,
      );
      
      widget.onSave(product);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Title
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Product Title',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a title';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // Price
          TextFormField(
            controller: _priceController,
            decoration: const InputDecoration(
              labelText: 'Price',
              prefixText: '\$',
              border: OutlineInputBorder(),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a price';
              }
              final price = double.tryParse(value);
              if (price == null || price <= 0) {
                return 'Please enter a valid price';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // Category
          TextFormField(
            controller: _categoryController,
            decoration: const InputDecoration(
              labelText: 'Category',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a category';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // Image URL
          TextFormField(
            controller: _imageUrlController,
            decoration: const InputDecoration(
              labelText: 'Image URL',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an image URL';
              }
              // Simple URL validation
              if (!value.startsWith('http')) {
                return 'Please enter a valid URL';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // Description
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
            maxLines: 5,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a description';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          
          // Submit Button
          ElevatedButton(
            onPressed: _submitForm,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text(
              widget.initialProduct == null ? 'Add Product' : 'Save Changes',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
