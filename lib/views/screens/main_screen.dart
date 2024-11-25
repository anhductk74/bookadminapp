import 'package:bookadminapp/views/screens/side_bar_screens/Product_Screen.dart';
import 'package:bookadminapp/views/screens/side_bar_screens/dashboard_screen.dart';
import 'package:bookadminapp/views/screens/side_bar_screens/user_screen.dart';
import 'package:bookadminapp/views/screens/side_bar_screens/Category_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Widget _selecttedItem = DashboardScreen();

  // This function will select the screen based on the sidebar item clicked
  screenSelector(item) {
    switch (item.route) {
      case DashboardScreen.routeName:
        setState(() {
          _selecttedItem = DashboardScreen();
        });
        break;
      case UserScreen.routeName:
        setState(() {
          _selecttedItem = UserScreen();
        });
        break;
      case CategoryScreen.routeName:
        setState(() {
          _selecttedItem = CategoryScreen();
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow.shade900,
        title: Text('Management'),
      ),
      backgroundColor: Colors.white,
      sideBar: SideBar(
        items: [
          AdminMenuItem(
              title: 'Dashboard',
              icon: Icons.dashboard,
              route: DashboardScreen.routeName),
          AdminMenuItem(
              title: 'Users',
              icon: CupertinoIcons.person_3,
              route: UserScreen.routeName),
          AdminMenuItem(
              title: 'Category',
              icon: CupertinoIcons.money_dollar,
              route: CategoryScreen.routeName),
        ],
        selectedRoute: '',
        onSelected: (item) {
          screenSelector(item);
        },
        header: Container(
          height: 50,
          width: double.infinity,
          color: const Color(0xff444444),
          child: const Center(
            child: Text(
              'Book App',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        footer: Container(
          height: 50,
          width: double.infinity,
          color: const Color(0xff444444),
          child: const Center(
            child: Text(
              'footer',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: _selecttedItem,
    );
  }
}
