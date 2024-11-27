import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _searchController =
      TextEditingController(); // Controller cho input tìm kiếm
  String? _searchQuery;

  // Hàm lọc đơn hàng theo orderId
  Stream<QuerySnapshot> _getOrdersStream() {
    if (_searchQuery != null && _searchQuery!.isNotEmpty) {
      return _firestore
          .collection('orders')
          .where('orderId', isEqualTo: _searchQuery) // Lọc theo orderId
          .snapshots();
    } else {
      return _firestore
          .collection('orders')
          .orderBy('timestamp', descending: true)
          .snapshots(); // Nếu không có tìm kiếm, hiển thị tất cả
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Management"),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by Order ID',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      _searchQuery = _searchController.text.trim();
                    });
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _getOrdersStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No orders found.'));
                }

                final orders = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    var order = orders[index].data() as Map<String, dynamic>;
                    String orderId = orders[index].id;
                    var items = List<Map<String, dynamic>>.from(order['items']);
                    String address = order['address'] ?? 'No address';
                    String name = order['name'] ?? 'No name';
                    String phone = order['phone'] ?? 'No phone';
                    double total = order['total']?.toDouble() ?? 0.0;
                    String status = order['status'] ?? 'unconform';
                    var timestamp = (order['timestamp'] as Timestamp).toDate();

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Order placed on: ${timestamp.toLocal()}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('Name: $name'),
                            Text('Phone: $phone'),
                            Text('Address: $address'),
                            const SizedBox(height: 10),
                            // Hiển thị các sản phẩm trong đơn hàng
                            for (var item in items)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Row(
                                  children: [
                                    Image.network(
                                      item['productImage'],
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(item['productName']),
                                        Text('Quantity: ${item['cartQty']}'),
                                        Text(
                                            'Price: ${item['productPrice']} VND'),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            const Divider(),
                            Text('Total: $total VND',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Hiển thị trạng thái đơn hàng
                                Text('Status: $status'),
                                Row(
                                  children: [
                                    // Thay đổi trạng thái nếu đơn hàng là "unconform"
                                    if (status == 'unconform')
                                      IconButton(
                                        icon: const Icon(Icons.check_circle),
                                        onPressed: () async {
                                          // Cập nhật trạng thái đơn hàng thành "conform"
                                          await _firestore
                                              .collection('orders')
                                              .doc(orderId)
                                              .update({'status': 'conform'});
                                        },
                                      ),
                                    // Nút chuyển sang trạng thái "đang giao hàng"
                                    if (status == 'conform')
                                      IconButton(
                                        icon: const Icon(Icons.local_shipping),
                                        onPressed: () async {
                                          // Cập nhật trạng thái đơn hàng thành "shipping"
                                          await _firestore
                                              .collection('orders')
                                              .doc(orderId)
                                              .update({'status': 'shipping'});
                                        },
                                      ),
                                    // Nút chuyển sang trạng thái "hoàn tất"
                                    if (status == 'shipping')
                                      IconButton(
                                        icon: const Icon(
                                            Icons.check_circle_outline),
                                        onPressed: () async {
                                          // Cập nhật trạng thái đơn hàng thành "complete"
                                          await _firestore
                                              .collection('orders')
                                              .doc(orderId)
                                              .update({'status': 'complete'});
                                        },
                                      ),
                                    // Nút xóa đơn hàng
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      onPressed: () async {
                                        // Xóa đơn hàng
                                        await _firestore
                                            .collection('orders')
                                            .doc(orderId)
                                            .delete();
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
