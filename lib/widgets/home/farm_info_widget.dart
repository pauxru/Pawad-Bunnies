import 'package:flutter/material.dart';

class FarmInfoWidget extends StatefulWidget {
  const FarmInfoWidget({Key? key}) : super(key: key);

  @override
  State<FarmInfoWidget> createState() => _FarmInfoWidgetState();
}

class _FarmInfoWidgetState extends State<FarmInfoWidget> {
  late Future<Map<String, String>> _farmInfoFuture;

  @override
  void initState() {
    super.initState();
    _farmInfoFuture = _fetchMockFarmInfo();
  }

  Future<Map<String, String>> _fetchMockFarmInfo() async {
    await Future.delayed(const Duration(seconds: 1)); // simulate network delay
    return {
      "name": "Pawad Rabbitry",
      "since": "2020",
      "location": "Nyeri, Kenya",
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String>>(
      future: _farmInfoFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Failed to load farm info'));
        } else if (!snapshot.hasData) {
          return const SizedBox();
        }

        final data = snapshot.data!;
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: Colors.teal.shade50,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.teal.withOpacity(0.1),
                  ),
                  child: const Icon(Icons.agriculture, color: Colors.teal, size: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data["name"]!,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text("Since ${data["since"]!}", style: const TextStyle(color: Colors.black54)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(data["location"]!, style: const TextStyle(color: Colors.black54)),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.verified, color: Colors.green, size: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}
