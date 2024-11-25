import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Lấy danh sách người dùng từ Firestore
  Stream<List<User>> getUsers() {
    return _db.collection('users').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) =>
              User.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    });
  }

  // Xóa người dùng khỏi Firestore
  Future<void> deleteUser(String userId) {
    return _db.collection('users').doc(userId).delete();
  }
}
