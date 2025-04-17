
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce_app/models/product.dart';
import 'package:ecommerce_app/providers/product_provider.dart';
import 'package:ecommerce_app/widgets/product_card.dart';
import 'package:ecommerce_app/widgets/app_scaffold.dart';
import 'package:ecommerce_app/widgets/empty_state.dart';
import 'package:ecommerce_app/screens/product_form_screen.dart';
import 'package:ecommerce_app/screens/product_detail_screen.dart';

class ProductsScreen extends StatefulWidget {
  static const routeName = '/';
  
  const ProductsScreen({Key? key}) : super(key: key);
  
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  bool _isInit = false;
  String _searchQuery = '';
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    if (!_isInit) {
      _fetchProducts();
      _isInit = true;
    }
  }
  
  Future<void> _fetchProducts() async {
    final productProvider = 
        Provider.of<ProductProvider>(context, listen: false);
    await productProvider.fetchProducts();
  }
  
  List<Product> _getFilteredProducts() {
    final productProvider = Provider.of<ProductProvider>(context);
    final allProducts = productProvider.allProducts;
    
    if (_searchQuery.isEmpty) {
      return allProducts;
    }
    
    return allProducts
        .where((product) => 
            product.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            product.category.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }
  
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final filteredProducts = _getFilteredProducts();
    final isLoading = productProvider.isLoading;
    
    return AppScaffold(
      title: 'Products',
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () => _showSearchDialog(context),
        ),
      ],
      body: RefreshIndicator(
        onRefresh: _fetchProducts,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : filteredProducts.isEmpty
                ? EmptyState(
                    icon: Icons.shopping_bag,
                    title: 'No Products Found',
                    message: _searchQuery.isNotEmpty
                        ? 'No products match your search.\nTry a different search term.'
                        : 'There are no products available.\nPull down to refresh or add a new product.',
                    buttonText: 'Add Product',
                    onButtonPressed: () => _navigateToAddProduct(context),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: filteredProducts.length,
                    itemBuilder: (ctx, i) => ProductCard(
                      product: filteredProducts[i],
                      onTap: () => _navigateToProductDetail(
                          context, filteredProducts[i]),
                      onEdit: filteredProducts[i].isLocallyAdded
                          ? () => _navigateToEditProduct(
                              context, filteredProducts[i])
                          : null,
                      onDelete: filteredProducts[i].isLocallyAdded
                          ? () => _showDeleteConfirmation(
                              context, filteredProducts[i])
                          : null,
                    ),
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddProduct(context),
        child: const Icon(Icons.add),
      ),
    );
  }
  
  void _showSearchDialog(BuildContext context) {
    final TextEditingController searchController = 
        TextEditingController(text: _searchQuery);
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Search Products'),
        content: TextField(
          controller: searchController,
          decoration: const InputDecoration(
            hintText: 'Enter product name or category',
            prefixIcon: Icon(Icons.search),
          ),
          onSubmitted: (value) {
            setState(() => _searchQuery = value);
            Navigator.of(context).pop();
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() => _searchQuery = '');
              Navigator.of(context).pop();
            },
            child: const Text('CLEAR'),
          ),
          TextButton(
            onPressed: () {
              setState(() => _searchQuery = searchController.text);
              Navigator.of(context).pop();
            },
            child: const Text('SEARCH'),
          ),
        ],
      ),
    );
  }
  
  void _navigateToProductDetail(BuildContext context, Product product) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => ProductDetailScreen(product: product),
      ),
    );
  }
  
  void _navigateToAddProduct(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const ProductFormScreen(),
        fullscreenDialog: true,
      ),
    );
  }
  
  void _navigateToEditProduct(BuildContext context, Product product) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => ProductFormScreen(product: product),
        fullscreenDialog: true,
      ),
    );
  }
  
  void _showDeleteConfirmation(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Product'),
        content: Text(
          'Are you sure you want to delete "${product.title}"?'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              final productProvider = 
                  Provider.of<ProductProvider>(context, listen: false);
                  
              productProvider.deleteLocalProduct(product.id);
              Navigator.of(context).pop();
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${product.title} deleted'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('DELETE'),
          ),
        ],
      ),
    );
  }
}
