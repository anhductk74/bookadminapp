import 'package:bookadminapp/views/screens/side_bar_screens/Product_Screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bookadminapp/models/category.dart';
import 'package:bookadminapp/services/category_service.dart';

class CategoryScreen extends StatefulWidget {
  static const String routeName = '\CategoryScreen';

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final CategoryService _categoryService = CategoryService();
  List<Category> _categories = [];

  // Controller để nhập tên, slug và đường dẫn ảnh
  TextEditingController nameController = TextEditingController();
  TextEditingController slugController = TextEditingController();
  TextEditingController imageUrlController =
      TextEditingController(); // Controller cho URL ảnh

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  // Hàm lấy danh sách danh mục từ Firebase
  Future<void> _fetchCategories() async {
    final categories = await _categoryService.fetchCategories();
    setState(() {
      _categories = categories;
    });
  }

  // Thêm danh mục mới
  void _addCategory() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Category'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: slugController,
              decoration: InputDecoration(labelText: 'Slug'),
            ),
            TextField(
              controller: imageUrlController,
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
                  slugController.text.isNotEmpty &&
                  imageUrlController.text.isNotEmpty) {
                // Tạo đối tượng Category mới
                Category newCategory = Category(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: nameController.text,
                  slug: slugController.text,
                  image: imageUrlController.text, // Lấy URL ảnh từ input
                );
                await _categoryService.addCategory(newCategory);
                _fetchCategories(); // Lấy lại danh sách category
                // Xoá text sau khi thêm category
                nameController.clear();
                slugController.clear();
                imageUrlController.clear();
                Navigator.pop(context);
              } else {
                // Nếu không nhập đủ thông tin
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please fill all fields')),
                );
              }
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  // Sửa danh mục
  void _editCategory(Category category) {
    nameController.text = category.name;
    slugController.text = category.slug;
    imageUrlController.text = category.image;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Category'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: slugController,
              decoration: InputDecoration(labelText: 'Slug'),
            ),
            TextField(
              controller: imageUrlController,
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
                  slugController.text.isNotEmpty &&
                  imageUrlController.text.isNotEmpty) {
                await _categoryService.updateCategory(
                  category.id,
                  nameController.text,
                  slugController.text,
                  imageUrlController.text,
                );
                _fetchCategories();
                Navigator.pop(context);
                // Xoá text sau khi cập nhật
                nameController.clear();
                slugController.clear();
                imageUrlController.clear();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please fill all fields')),
                );
              }
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }

  // Xóa danh mục
  void _deleteCategory(String id) async {
    await _categoryService.deleteCategory(id);
    _fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manage Category',
          style: TextStyle(fontWeight: FontWeight.bold), // In đậm tiêu đề
        ),
      ),
      body: _categories.isEmpty
          ? Center(
              child: Text(
                  'No categories available')) // Hiển thị khi không có category nào
          : ListView.builder(
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                return ListTile(
                    leading: category.image.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: category.image,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.broken_image),
                          )
                        : Icon(Icons.broken_image),
                    title: Text(category.name),
                    subtitle: Text(category.slug),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => _editCategory(category),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deleteCategory(category.id),
                        ),
                      ],
                    ),
                    onTap: () {
                      // Navigate and pass both categoryId and categoryName
                      Navigator.pushNamed(
                        context,
                        ProductsScreen.routeName,
                        arguments: {
                          'categoryId': category.id,
                          'categoryName': category.name,
                        },
                      );
                    });
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addCategory,
        child: Icon(Icons.add),
      ),
    );
  }
}
