// farm_status_widget.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FarmStatusWidget extends StatelessWidget {
  const FarmStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final temperature = 26.5;
    final dateTime = DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now());

    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Farm Status', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text('Temperature: $temperature°C'),
            Text('Date & Time: $dateTime'),
          ],
        ),
      ),
    );
  }
}
