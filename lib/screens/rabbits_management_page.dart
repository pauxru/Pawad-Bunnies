import 'package:flutter/material.dart';
import '../models/rabbit.dart';
import '../services/rabbit_api_service.dart';
import '../widgets/rabbit_list_widget.dart';
import 'new_rabbit.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/base_scaffold.dart'; // <-- Add this import

class RabbitManagement extends StatefulWidget {
  const RabbitManagement({Key? key}) : super(key: key);

  @override
  State<RabbitManagement> createState() => _RabbitManagementState();
}

class _RabbitManagementState extends State<RabbitManagement> {
  int _selectedIndex = 0;

  void _onNavBarTap(int index) {
    setState(() {
      _selectedIndex = 2;
    });
  }

  final List<Widget> _pages = const [
    RabbitListPage(),
    Center(child: Text("Tasks Page", style: TextStyle(fontSize: 20))),
    Center(child: Text("Rabbits Page", style: TextStyle(fontSize: 20))),
    Center(child: Text("Profile Page", style: TextStyle(fontSize: 20))),
  ];

  final List<String?> _titles = const [
    'Rabbit Manager',
    'Tasks',
    'Rabbits',
    'Profile',
  ];

  @override
Widget build(BuildContext context) {
  return BaseScaffold(
    currentIndex: 2, // Rabbits tab index
    title: 'Rabbits Management',
    child: Stack(
      children: [
        const RabbitListPage(),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NewRabbitPage(),
                ),
              );
            },
            child: const Icon(Icons.add),
          ),
        ),
      ],
    ),
  );
}

}

class RabbitListPage extends StatelessWidget {
  const RabbitListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final apiService = RabbitApiService();
    return FutureBuilder<List<Rabbit>>(
      future: apiService.getRabbits(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No rabbits available.'));
        } else {
          return RabbitListWidget(rabbits: snapshot.data!);
        }
      },
    );
  }
}
