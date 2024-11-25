import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bookadminapp/models/category.dart';

class CategoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Lấy danh sách tất cả danh mục
  Future<List<Category>> fetchCategories() async {
    QuerySnapshot snapshot = await _firestore.collection('categories').get();
    return snapshot.docs
        .map((doc) => Category(
              id: doc.id,
              name: doc['name'],
              slug: doc['slug'],
              image: doc['image'] ?? '', // Lấy URL ảnh từ Firestore
            ))
        .toList();
  }

  // Thêm danh mục mới
  Future<void> addCategory(Category category) async {
    try {
      // Kiểm tra nếu URL ảnh không rỗng
      if (category.image.isNotEmpty) {
        await _firestore.collection('categories').add({
          'name': category.name,
          'slug': category.slug,
          'image': category.image, // Lưu URL ảnh vào Firestore
        });
      } else {
        // Nếu không có ảnh, lưu danh mục mà không có URL ảnh
        await _firestore.collection('categories').add({
          'name': category.name,
          'slug': category.slug,
          'image': '', // Không có ảnh
        });
      }
    } catch (e) {
      print('Error adding category: $e');
    }
  }

  // Cập nhật danh mục
  Future<void> updateCategory(
    String id,
    String name,
    String slug,
    String image,
  ) async {
    try {
      await _firestore.collection('categories').doc(id).update({
        'name': name,
        'slug': slug,
        'image': image, // Cập nhật URL ảnh
      });
    } catch (e) {
      print('Error updating category: $e');
    }
  }

  // Xóa danh mục
  Future<void> deleteCategory(String id) async {
    try {
      await _firestore.collection('categories').doc(id).delete();
    } catch (e) {
      print('Error deleting category: $e');
    }
  }
}
