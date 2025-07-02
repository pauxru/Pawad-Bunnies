// sick_rabbits_widget.dart
import 'package:flutter/material.dart';

class SickRabbitsWidget extends StatelessWidget {
  const SickRabbitsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final sickCount = 4;

    return Card(
      margin: const EdgeInsets.all(8),
      color: Colors.red.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Sick Rabbits', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red)),
            const SizedBox(height: 12),
            Text('Currently Sick: $sickCount', style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}