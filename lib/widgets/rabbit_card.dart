import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/rabbit.dart';
import '../screens/rabbit_details.dart';
import 'placeholder_image.dart';

class RabbitCard extends StatelessWidget {
  final Rabbit rabbit;

  const RabbitCard({super.key, required this.rabbit});

  int _calculateAgeInMonths(DateTime birthday) {
      final now = DateTime.now();
      int months = (now.year - birthday.year) * 12 + now.month - birthday.month;
      if (now.day < birthday.day) months -= 1;
      return months;
    }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RabbitDetails(rabbit: rabbit),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        margin: const EdgeInsets.all(8),
        shadowColor: Colors.teal.shade100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 180,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: rabbit.images.isNotEmpty
                    ? Image.network(
                        rabbit.images.first,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const PlaceholderImage(),
                      )
                    : const PlaceholderImage(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '🐰 Tag: ${rabbit.tagNo}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('Breed: ${rabbit.breed}'),
                  Text('Sex: ${rabbit.sex}'),
                  if (rabbit.birthday != null)
                      Text(
                        'Age: ${_calculateAgeInMonths(rabbit.birthday!)} months',
                        style: const TextStyle(color: Colors.grey),
                      ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
