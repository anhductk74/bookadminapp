import 'package:bookadminapp/models/user.dart';
import 'package:bookadminapp/services/user_service.dart';
import 'package:flutter/material.dart';

class UserScreen extends StatelessWidget {
  static const String routeName = '/UserScreen';
  final UserService userService = UserService();

  // Hàm để điều hướng đến màn hình sửa hoặc mở hộp thoại
  void editCourse(BuildContext context, User user) {
    // Mở hộp thoại hoặc điều hướng đến màn hình sửa chi tiết ở đây
    // Ví dụ: Navigator.pushNamed(context, EditCourseScreen.routeName, arguments: user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manage Users',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 36,
          ),
        ),
      ),
      body: StreamBuilder<List<User>>(
        stream: userService.getUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No users available.'));
          }

          var users = snapshot.data!;

          return SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Table(
                border: TableBorder.all(),
                columnWidths: {
                  1: FlexColumnWidth(6),
                  2: FlexColumnWidth(6),
                  3: FlexColumnWidth(2), // Nút Sửa
                  4: FlexColumnWidth(2), // Nút Xóa
                },
                children: [
                  // Hàng tiêu đề
                  TableRow(
                    decoration: BoxDecoration(color: Colors.grey[300]),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'ID',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Name',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Email',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Edit',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Delete',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  // Hiển thị dữ liệu từ Firebase và ID tự động tăng
                  ...List.generate(users.length, (index) {
                    var user = users[index];
                    return TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              (index + 1).toString(), // ID tự động tăng từ 1
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(user.name),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(user.email),
                        ),
                        // Nút Sửa
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => editCourse(context, user),
                          ),
                        ),
                        // Nút Xóa
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              userService.deleteUser(user.id);
                            },
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
