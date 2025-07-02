// cages_widget.dart
import 'package:flutter/material.dart';

class CagesWidget extends StatelessWidget {
  const CagesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cageCount = 12;

    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Cages', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text('Total Cages: $cageCount'),
          ],
        ),
      ),
    );
  }
}