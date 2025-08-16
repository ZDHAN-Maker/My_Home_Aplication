import 'package:flutter/material.dart';

class KeamananPage extends StatelessWidget {
  const KeamananPage({super.key});

  final List<Map<String, dynamic>> keamananItems = const [
    {"title": "CCTV", "icon": Icons.videocam},
    {"title": "Pagar Otomatis", "icon": Icons.garage},
    {"title": "Alarm Kebakaran", "icon": Icons.fire_extinguisher},
    {"title": "Sensor Gerak", "icon": Icons.sensors},
    {"title": "Smart Lock", "icon": Icons.lock},
    {"title": "Lampu Otomatis", "icon": Icons.lightbulb},
    {"title": "Sirine Darurat", "icon": Icons.warning},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Keamanan')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: keamananItems.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Membuka fitur ${keamananItems[index]["title"]}'),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(keamananItems[index]["icon"], size: 40, color: Colors.blue),
                    const SizedBox(height: 8),
                    Text(
                      keamananItems[index]["title"],
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
