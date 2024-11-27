import 'package:bookadminapp/firebase_options.dart';
import 'package:bookadminapp/views/screens/side_bar_screens/Product_Screen.dart'; // Import ProductsScreen
import 'package:bookadminapp/views/screens/side_bar_screens/dashboard_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Book Store',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const DashboardScreen(),
      // Add routes here
      routes: {
        ProductsScreen.routeName: (context) {
          // Correct way to extract categoryId and categoryName from arguments map
          final arguments =
              ModalRoute.of(context)!.settings.arguments as Map<String, String>;
          final categoryId = arguments['categoryId']!;
          final categoryName = arguments['categoryName']!;

          return ProductsScreen(
            categoryId: categoryId,
            categoryName: categoryName,
          );
        },
      },
    );
  }
}
