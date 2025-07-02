// age_bracket_widget.dart
import 'package:flutter/material.dart';

class AgeBracketWidget extends StatelessWidget {
  const AgeBracketWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ageBrackets = {
      '< 1 month': 10,
      '1-3 months': 25,
      '3-6 months': 15,
      '> 6 months': 5,
    };

    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Age Brackets', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...ageBrackets.entries.map((e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text('${e.key}: ${e.value}'),
            ))
          ],
        ),
      ),
    );
  }
}