// File: widgets/hero_images_carousel.dart
import 'package:flutter/material.dart';

class HeroImagesCarousel extends StatelessWidget {
  final List<String> imageUrls;

  const HeroImagesCarousel({super.key, required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: PageView.builder(
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                imageUrls[index],
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}