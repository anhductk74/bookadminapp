import 'package:bookadminapp/models/user.dart';
import 'package:bookadminapp/services/user_service.dart';
import 'package:flutter/material.dart';

class UserScreen extends StatelessWidget {
  static const String routeName = '/UserScreen';
  final UserService userService = UserService();

  UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manage Users',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 24, // Adjusted for better readability
          ),
        ),
      ),
      body: StreamBuilder<List<User>>(
        stream: userService.getUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No users available.'));
          }

          var users = snapshot.data!;

          return SingleChildScrollView(
            padding:
                const EdgeInsets.all(16), // More padding for better spacing
            child: DataTable(
              columnSpacing: 16.0, // Increase spacing between columns
              columns: const [
                DataColumn(
                    label: Text('ID',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Name',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Email',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Delete',
                        style: TextStyle(fontWeight: FontWeight.bold))),
              ],
              rows: List.generate(users.length, (index) {
                var user = users[index];
                return DataRow(
                  cells: [
                    DataCell(Center(
                        child:
                            Text((index + 1).toString()))), // Auto increment ID
                    DataCell(Text(user.name)),
                    DataCell(Text(user.email)),
                    DataCell(
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          userService.deleteUser(user.id);
                        },
                      ),
                    ),
                  ],
                );
              }),
            ),
          );
        },
      ),
    );
  }
}
