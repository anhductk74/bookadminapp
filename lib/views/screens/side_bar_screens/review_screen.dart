import 'package:bookadminapp/models/user.dart';
import 'package:bookadminapp/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart'; // Để sử dụng Clipboard

class ReviewsScreen extends StatefulWidget {
  @override
  _FeedbackListScreenState createState() => _FeedbackListScreenState();
}

class _FeedbackListScreenState extends State<ReviewsScreen> {
  // Map để lưu trữ tên người dùng theo userId
  Map<String, String> userNames = {};

  // Hàm lấy tên người dùng theo userId
  Future<void> _fetchUserName(String userId) async {
    // Nếu chưa có tên người dùng trong map thì thực hiện gọi API lấy tên người dùng
    if (!userNames.containsKey(userId)) {
      User? user = await UserService.getUserById(userId);
      if (user != null) {
        setState(() {
          userNames[userId] = user.name;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Feedbacks"),
        backgroundColor: Colors.teal, // Thêm màu cho app bar
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('feedbacks')
            .orderBy('timestamp', descending: true) // Sắp xếp từ mới đến cũ
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return Center(child: Text("No feedback available"));
          }

          var feedbacks = snapshot.data!.docs;

          return ListView.builder(
            itemCount: feedbacks.length,
            itemBuilder: (context, index) {
              var feedbackData =
                  feedbacks[index].data() as Map<String, dynamic>;
              String feedback = feedbackData['feedback'] ?? '';
              String orderId = feedbackData['orderId'] ?? '';
              Timestamp timestamp =
                  feedbackData['timestamp'] ?? Timestamp.now();
              String userId = feedbackData['userId'] ?? '';
              String userName =
                  userNames[userId] ?? 'Loading...'; // Mặc định là 'Loading...'

              // Gọi _fetchUserName để lấy tên người dùng nếu chưa có trong userNames map
              _fetchUserName(userId);

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      "Feedback: $feedback",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                        Text("Order ID: $orderId",
                            style: TextStyle(fontSize: 16)),
                        SizedBox(height: 4),
                        Text("User: $userName", style: TextStyle(fontSize: 16)),
                        SizedBox(height: 4),
                        Text("User ID: $userId",
                            style: TextStyle(fontSize: 16)),
                        SizedBox(height: 4),
                        Text("Timestamp: ${timestamp.toDate()}",
                            style: TextStyle(fontSize: 14, color: Colors.grey)),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.copy, color: Colors.blue),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(
                            text: orderId)); // Sao chép orderId vào clipboard
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Order ID copied to clipboard!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
