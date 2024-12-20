import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});

  // Chuyển đổi từ Firestore DocumentSnapshot thành đối tượng User
  factory User.fromFirestore(Map<String, dynamic> firestoreData, String id) {
    return User(
      id: id,
      name: firestoreData['name'] ?? 'N/A',
      email: firestoreData['email'] ?? 'N/A',
    );
  }

  // Hàm tĩnh để lấy thông tin người dùng từ Firestore theo id
}
