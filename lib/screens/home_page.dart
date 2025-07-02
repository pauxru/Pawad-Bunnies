import 'package:flutter/material.dart';
import '../widgets/home/farm_stats_widget.dart';
import '../widgets/home/farm_info_widget.dart';
import '../widgets/home/rabbit_gender_widget.dart';
import '../widgets/home/age_bracket_widget.dart';
import '../widgets/home/sick_rabbits_widget.dart';
import '../widgets/home/cages_widget.dart';
import '../widgets/home/feeds_widget.dart';
import '../widgets/home/farm_status_widget.dart';
// import '../widgets/home/hero_images_carousel.dart';
import '../widgets/base_scaffold.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      currentIndex: 0,
      title: "Farm Dashboard",
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            FarmInfoWidget(),
            SizedBox(height: 16),
            // HeroImagesCarousel(imageUrls: []),
            // SizedBox(height: 16),
            FarmStatusWidget(),
            SizedBox(height: 32),
            FarmStatsWidget(),
            SizedBox(height: 16),
            RabbitGenderWidget(),
            SizedBox(height: 16),
            AgeBracketWidget(),
            SizedBox(height: 16),
            SickRabbitsWidget(),
            SizedBox(height: 16),
            CagesWidget(),
            SizedBox(height: 16),
            FeedsWidget(),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
