// rabbit_gender_widget.dart
import 'package:flutter/material.dart';

class RabbitGenderWidget extends StatelessWidget {
  const RabbitGenderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data
    final maleCount = 20;
    final femaleCount = 35;

    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Gender Distribution', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Males: $maleCount'),
                Text('Females: $femaleCount'),
              ],
            )
          ],
        ),
      ),
    );
  }
}