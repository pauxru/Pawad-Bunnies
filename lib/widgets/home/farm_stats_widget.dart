// File: widgets/farm_stats_widget.dart
import 'package:flutter/material.dart';

class FarmStatsWidget extends StatelessWidget {
  const FarmStatsWidget({super.key});

  Future<Map<String, int>> fetchStats() async {
    await Future.delayed(const Duration(seconds: 1));
    return {
      'total': 56,
      'pregnant': 8,
      'sick': 3,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<Map<String, int>>(
          future: fetchStats(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final data = snapshot.data!;
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStat('Total', data['total']!),
                _buildStat('Pregnant', data['pregnant']!),
                _buildStat('Sick', data['sick']!),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildStat(String label, int value) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(label),
      ],
    );
  }
}