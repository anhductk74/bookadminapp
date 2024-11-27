// models/order.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  final String orderId;
  final String name;
  final String phone;
  final String address;
  final List<Item> items;
  final double total;
  final String status;
  final DateTime timestamp;

  Order({
    required this.orderId,
    required this.name,
    required this.phone,
    required this.address,
    required this.items,
    required this.total,
    required this.status,
    required this.timestamp,
  });

  factory Order.fromMap(Map<String, dynamic> data, String documentId) {
    var itemsList =
        (data['items'] as List).map((item) => Item.fromMap(item)).toList();

    return Order(
      orderId: documentId,
      name: data['name'] ?? 'No name',
      phone: data['phone'] ?? 'No phone',
      address: data['address'] ?? 'No address',
      items: itemsList,
      total: data['total']?.toDouble() ?? 0.0,
      status: data['status'] ?? 'unconform',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }
}

class Item {
  final String productName;
  final String productImage;
  final int cartQty;
  final double productPrice;

  Item({
    required this.productName,
    required this.productImage,
    required this.cartQty,
    required this.productPrice,
  });

  factory Item.fromMap(Map<String, dynamic> data) {
    return Item(
      productName: data['productName'],
      productImage: data['productImage'],
      cartQty: data['cartQty'],
      productPrice: data['productPrice']?.toDouble() ?? 0.0,
    );
  }
}
