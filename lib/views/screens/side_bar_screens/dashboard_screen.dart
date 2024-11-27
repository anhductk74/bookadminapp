import 'package:bookadminapp/services/OrderService.dart';
import 'package:bookadminapp/views/card/ManagementCard.dart';
import 'package:bookadminapp/views/card/StatCard.dart';
import 'package:bookadminapp/views/screens/side_bar_screens/Category_screen.dart';
import 'package:bookadminapp/views/screens/side_bar_screens/order_screen.dart';
import 'package:bookadminapp/views/screens/side_bar_screens/review_screen.dart';
import 'package:bookadminapp/views/screens/side_bar_screens/user_screen.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  static const String routeName = 'DashboardScreen';

  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final OrderService _firebaseService = OrderService();

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Phần tiêu đề Dashboard
              const Text(
                'Dashboard',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 36,
                ),
              ),
              SizedBox(height: 16),
              // Phần thống kê (dùng StreamBuilder thay cho FutureBuilder)
              StreamBuilder<Map<String, dynamic>>(
                stream: _firebaseService.getOrderStatisticsStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No data available.'));
                  } else {
                    final stats = snapshot.data!;
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: StatCard(
                                title: 'Tổng đơn',
                                value: stats['total'].toString(),
                                color: Colors.teal,
                              ),
                            ),
                            SizedBox(width: 16.0), // Adds space between cards
                            Expanded(
                              child: StatCard(
                                title: 'Chưa xác nhận',
                                value: stats['unconform'].toString(),
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                            height: 16.0), // Adds space between the two rows
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: StatCard(
                                title: 'Đơn đã giao',
                                value: stats['completed'].toString(),
                                color: Colors.blue,
                              ),
                            ),
                            SizedBox(width: 16.0),
                            Expanded(
                              child: StatCard(
                                title: 'Doanh thu',
                                value:
                                    '${stats['totalRevenue'].toString()} VND',
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                },
              ),
              SizedBox(height: 16),
              const Text(
                'Quản lý',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              // Các ô quản lý
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 3 / 2,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  ManagementCard(
                    title: 'Sản phẩm',
                    color: Colors.orange,
                    icon: Icons.storage,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CategoryScreen()),
                      );
                    },
                  ),
                  ManagementCard(
                    title: 'Đơn hàng',
                    color: Colors.purple,
                    icon: Icons.receipt_long,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => OrdersScreen()),
                      );
                    },
                  ),
                  ManagementCard(
                    title: 'Đánh giá',
                    color: Colors.green,
                    icon: Icons.comment,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ReviewsScreen()),
                      );
                    },
                  ),
                  ManagementCard(
                    title: 'Khách hàng',
                    color: Colors.blue,
                    icon: Icons.people,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UserScreen()),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
