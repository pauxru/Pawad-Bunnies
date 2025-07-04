import 'package:flutter/material.dart';
import 'screens/home_page.dart';
import 'screens/todo_page.dart';
import 'screens/rabbits_management_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rabbit App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/home': (context) => const HomeScreen(),
        '/tasks': (context) => const TodoListPage(),
        '/rabbits': (context) => const RabbitManagement()
      },
    );
  }
}
