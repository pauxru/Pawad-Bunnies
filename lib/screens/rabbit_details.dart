import 'package:flutter/material.dart';
import 'package:test_drive/main.dart';
import '../models/rabbit.dart';

class RabbitDetails extends StatelessWidget {
  final Rabbit rabbit;

  const RabbitDetails({super.key, required this.rabbit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(rabbit.tagNo),
        backgroundColor: Colors.blue[700],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 🖼️ Image Carousel
            SizedBox(
              height: 240,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: rabbit.images.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      rabbit.images[index],
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),

            // 🐰 Rabbit Info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _infoRow(Icons.cake, "Birthday", rabbit.birthday.toString().substring(0, 10)),
                      _infoRow(Icons.pets, "Breed", rabbit.breed),
                      _infoRow(Icons.male, "Father", rabbit.father),
                      _infoRow(Icons.female, "Mother", rabbit.mother),
                      _infoRow(Icons.transgender, "Sex", rabbit.sex),
                      _infoRow(Icons.home_work, "Cage No", rabbit.cage),
                      _infoRow(Icons.comment, "Comments", rabbit.comments),
                      _infoRow(Icons.healing, "Diseases", rabbit.diseases),
                      _infoRow(Icons.public, "Origin", rabbit.origin),
                      _infoRow(Icons.attach_money, "Price Sold", rabbit.priceSold),
                      _infoRow(Icons.monitor_weight, "Weight", rabbit.weight),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String? value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.blue[600]),
        const SizedBox(width: 12),
        Expanded(
          flex: 3,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ),
        Expanded(
          flex: 5,
          child: Text(
            value ?? 'N/A',
            style: const TextStyle(fontSize: 15),
            softWrap: true,
          ),
        ),
      ],
    ),
  );
}

}
