import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Tambahkan import ini

import './cctv.dart';
import './Automatic_Wall.dart';
import './alarm.dart';
import './sirine_darurat.dart';
import './otomatic_lampu.dart';
import './sensor_gerak.dart';
import './smart_lock.dart';

class KeamananPage extends StatelessWidget {
  const KeamananPage({super.key});

  final List<Map<String, dynamic>> keamananItems = const [
    {"title": "CCTV", "icon": Icons.videocam, "page": CCTVPage()},
    {"title": "Pagar Otomatis", "icon": Icons.garage, "page": AutomaticWall()},
    {"title": "Alarm Kebakaran", "icon": Icons.fire_extinguisher, "page": Alarm()},
    {"title": "Sensor Gerak", "icon": Icons.sensors, "page": SensorGerak()},
    {"title": "Smart Lock", "icon": Icons.lock, "page": SmartLock()},
    {"title": "Lampu Otomatis", "icon": Icons.lightbulb, "page": OtomaticLampu()},
    {"title": "Sirine Darurat", "icon": Icons.warning, "page": SirineDarurat()},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Keamanan',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF1b263b),
        iconTheme: const IconThemeData(color: Colors.white), // Tombol kembali berwarna putih
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0d1b2a), Color(0xFF1b263b)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
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
              final item = keamananItems[index];
              return Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: const Color(0xFF415a77), // Warna kartu yang serasi
                child: InkWell(
                  onTap: () {
                    // Navigasi ke halaman yang sesuai
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => item["page"] as Widget),
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(item["icon"] as IconData, size: 40, color: Colors.cyanAccent),
                      const SizedBox(height: 8),
                      Text(
                        item["title"] as String,
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
