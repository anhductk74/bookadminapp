import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bookadminapp/models/product.dart';

class ProductService {
  final _productsCollection = FirebaseFirestore.instance.collection('products');

  // Fetch products by category ID
  Future<List<Products>> fetchProducts(String categoryId) async {
    try {
      final snapshot = await _productsCollection
          .where('category_id', isEqualTo: categoryId)
          .get();
      return snapshot.docs
          .map((doc) => Products.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print("Error fetching products: $e");
      throw Exception("Failed to fetch products");
    }
  }

  // Add a new product
  Future<void> addProduct(Products product) async {
    try {
      await _productsCollection.add({
        'name': product.name,
        'category_id': product.categoryId,
        'price': product.price,
        'qty': product.qty,
        'description': product.description,
        'image': product.image,
        'createAT': product.createAT,
      });
    } catch (e) {
      print("Error adding product: $e");
      throw Exception("Failed to add product");
    }
  }

  // Update an existing product
  Future<void> updateProduct(String productId, Products product) async {
    try {
      await _productsCollection.doc(productId).update({
        'name': product.name,
        'price': product.price,
        'qty': product.qty,
        'description': product.description,
        'image': product.image,
        // Do not update createAT
      });
    } catch (e) {
      print("Error updating product: $e");
      throw Exception("Failed to update product");
    }
  }

  // Delete a product
  Future<void> deleteProduct(String productId) async {
    try {
      await _productsCollection.doc(productId).delete();
    } catch (e) {
      print("Error deleting product: $e");
      throw Exception("Failed to delete product");
    }
  }
}
