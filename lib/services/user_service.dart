import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Lấy danh sách người dùng từ Firestore
  Stream<List<User>> getUsers() {
    return _db.collection('users').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => User.fromFirestore(doc.data(), doc.id))
          .toList();
    });
  }

  // Xóa người dùng khỏi Firestore
  Future<void> deleteUser(String userId) {
    return _db.collection('users').doc(userId).delete();
  }

  static Future<User?> getUserById(String userId) async {
    try {
      // Truy vấn Firestore để lấy thông tin người dùng theo userId
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      // Kiểm tra xem tài liệu có tồn tại không
      if (documentSnapshot.exists) {
        // Chuyển dữ liệu Firestore thành đối tượng User
        return User.fromFirestore(
            documentSnapshot.data() as Map<String, dynamic>, userId);
      } else {
        return null; // Nếu không tìm thấy người dùng
      }
    } catch (e) {
      print("Error getting user: $e");
      return null; // Trả về null nếu có lỗi
    }
  }
}
