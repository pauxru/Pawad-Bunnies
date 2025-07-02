import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: Colors.teal,
      unselectedItemColor: Colors.grey,
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_filled),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.task_alt_rounded),
          label: 'Tasks',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.pets),
          label: 'Rabbits',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_rounded),
          label: 'Profile',
        ),
      ],
    );
  }
}
