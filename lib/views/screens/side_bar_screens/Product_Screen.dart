import 'package:bookadminapp/services/ProductService.dart';
import 'package:flutter/material.dart';
import 'package:bookadminapp/models/product.dart';

class ProductsScreen extends StatefulWidget {
  static const String routeName = '/ProductsScreen';

  final String categoryId;
  final String categoryName;

  ProductsScreen({
    required this.categoryId,
    required this.categoryName,
  });

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final ProductService _productService = ProductService();
  List<Products> _products = [];

  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController qtyController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      final products = await _productService.fetchProducts(widget.categoryId);
      setState(() {
        _products = products;
      });
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch products')),
      );
    }
  }

  Future<void> _addProduct() async {
    final newProduct = Products(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: nameController.text,
      categoryId: widget.categoryId,
      price: priceController.text,
      qty: qtyController.text,
      description: descriptionController.text,
      image: imageController.text,
      createAT: DateTime.now().toIso8601String(),
    );

    try {
      await _productService.addProduct(newProduct);
      _fetchProducts(); // Refresh product list
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add product')),
      );
    }
  }

  Future<void> _updateProduct(String productId) async {
    final updatedProduct = Products(
      id: productId,
      name: nameController.text,
      categoryId: widget.categoryId,
      price: priceController.text,
      qty: qtyController.text,
      description: descriptionController.text,
      image: imageController.text,
      createAT: '', // createAT is not updated
    );

    try {
      await _productService.updateProduct(productId, updatedProduct);
      _fetchProducts(); // Refresh product list
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update product')),
      );
    }
  }

  Future<void> _deleteProduct(String productId) async {
    try {
      await _productService.deleteProduct(productId);
      _fetchProducts(); // Refresh product list
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete product')),
      );
    }
  }

  void _showProductDialog({Products? product}) {
    if (product != null) {
      nameController.text = product.name;
      priceController.text = product.price;
      qtyController.text = product.qty;
      descriptionController.text = product.description;
      imageController.text = product.image;
    } else {
      nameController.clear();
      priceController.clear();
      qtyController.clear();
      descriptionController.clear();
      imageController.clear();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(product != null ? 'Edit Product' : 'Add Product'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'Price'),
            ),
            TextField(
              controller: qtyController,
              decoration: InputDecoration(labelText: 'Quantity'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: imageController,
              decoration: InputDecoration(labelText: 'Image URL'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty &&
                  priceController.text.isNotEmpty &&
                  qtyController.text.isNotEmpty &&
                  descriptionController.text.isNotEmpty &&
                  imageController.text.isNotEmpty) {
                if (product != null) {
                  await _updateProduct(product.id);
                } else {
                  await _addProduct();
                }
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please fill all fields')),
                );
              }
            },
            child: Text(product != null ? 'Update' : 'Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products for Category: ${widget.categoryName}'),
      ),
      body: _products.isEmpty
          ? Center(child: Text('No products available in this category'))
          : ListView.builder(
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                return ListTile(
                  leading: product.image.isNotEmpty
                      ? Image.network(
                          product.image,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                      : Icon(Icons.broken_image, size: 50),
                  title: Text(product.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Price: ${product.price}, Qty: ${product.qty}'),
                      Text('Description: ${product.description}'),
                      Text('Created At: ${product.createAT}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _showProductDialog(product: product),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteProduct(product.id),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showProductDialog(),
        child: Icon(Icons.add),
      ),
    );
  }
}
