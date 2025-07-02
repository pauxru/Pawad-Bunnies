import 'package:flutter/material.dart';

class PlaceholderImage extends StatelessWidget {
  const PlaceholderImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.pets,
      size: 48,
      color: Colors.grey,
    );
  }
}
