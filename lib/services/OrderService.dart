import 'package:cloud_firestore/cloud_firestore.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Phương thức trả về Stream thay vì Future
  Stream<Map<String, dynamic>> getOrderStatisticsStream() {
    return _firestore.collection('orders').snapshots().map((querySnapshot) {
      int totalOrders = querySnapshot.size;
      int completedOrders = 0;
      int unConformOrders = 0;
      double totalRevenue = 0;

      // Duyệt qua từng đơn hàng và đếm theo trạng thái, cộng doanh thu
      for (var doc in querySnapshot.docs) {
        String status = doc['status'];
        double orderTotal = doc['total']?.toDouble() ?? 0;

        if (status == 'complete') {
          completedOrders++;
          totalRevenue +=
              orderTotal; // Cộng doanh thu cho các đơn đã hoàn thành
        } else if (status == 'unconform') {
          unConformOrders++;
        }
      }

      // Trả về map các thống kê bao gồm doanh thu
      return {
        'total': totalOrders,
        'completed': completedOrders,
        'unconform': unConformOrders,
        'totalRevenue': totalRevenue,
      };
    });
  }

  // Phương thức để tìm kiếm đơn hàng theo orderId
  Stream<DocumentSnapshot> getOrderById(String orderId) {
    return _firestore
        .collection('orders')
        .doc(orderId) // Truy vấn theo orderId
        .snapshots();
  }
}
