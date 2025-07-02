
// File: widgets/feeds_widget.dart
import 'package:flutter/material.dart';

class FeedsWidget extends StatelessWidget {
  const FeedsWidget({super.key});

  Future<Map<String, dynamic>> fetchFeedData() async {
    await Future.delayed(const Duration(seconds: 1));
    return {
      'type': 'Pellets',
      'quantityKg': 120,
      'costPerKg': 25.0,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<Map<String, dynamic>>(
          future: fetchFeedData(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final data = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Feeds Info',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text('Type: ${data['type']}'),
                Text('Quantity: ${data['quantityKg']} Kg'),
                Text('Cost: KES ${data['costPerKg']}/Kg'),
              ],
            );
          },
        ),
      ),
    );
  }
}
