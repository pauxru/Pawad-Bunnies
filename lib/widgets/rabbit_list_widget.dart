import 'package:flutter/material.dart';
import '../models/rabbit.dart';
import 'rabbit_card.dart';

class RabbitListWidget extends StatelessWidget {
  final List<Rabbit> rabbits;

  const RabbitListWidget({Key? key, required this.rabbits}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (rabbits.isEmpty) {
      return const Center(child: Text("No rabbits found."));
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        itemCount: rabbits.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.65, // Adjust this value
        ),

        itemBuilder: (context, index) {
          return RabbitCard(rabbit: rabbits[index]);
        },
      ),
    );
  }
}
