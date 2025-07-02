import 'package:flutter/material.dart';
import 'bottom_nav_bar.dart';

class BaseScaffold extends StatelessWidget {
  final int currentIndex;
  final Widget child;
  final String? title;

  const BaseScaffold({
    super.key,
    required this.currentIndex,
    required this.child,
    this.title,
  });

  void _onItemTapped(BuildContext context, int index) {
    if (index == currentIndex) return; // Prevent navigating to the same page

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/tasks');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/rabbits');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: title != null ? AppBar(title: Text(title!)) : null,
      body: child,
      bottomNavigationBar: BottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) => _onItemTapped(context, index),
      ),
    );
  }
}
