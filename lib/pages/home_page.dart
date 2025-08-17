import 'package:flutter/material.dart';
import './keamanan_page.dart';
import './jadwal_page.dart';
import './stock_page.dart';
import './login_page.dart';
import './status_air_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> menuItems = [
    {"title": "Keamanan", "icon": Icons.security, "page": const KeamananPage()},
    {"title": "Jadwal", "icon": Icons.schedule, "page": const JadwalPage()},
    {"title": "Stock", "icon": Icons.inventory, "page": const StockPage()},
    {"title": "Status Air", "icon": Icons.water_drop, "page": const StatusAirPage()},
  ];

  bool keamananAktif = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage('assets/Images/Me.png'),
              radius: 22,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Selamat Datang,", style: TextStyle(fontSize: 14, color: Colors.grey)),
                Text("Zidhan 👋", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Ringkasan Status (Dashboard Cards)
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        keamananAktif = !keamananAktif; // toggle aktif/nonaktif
                      });
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Icon(
                              keamananAktif ? Icons.lock : Icons.lock_open,
                              color: keamananAktif ? Colors.green : Colors.red,
                              size: 32,
                            ),
                            const SizedBox(height: 8),
                            const Text("Keamanan", style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(
                              keamananAktif ? "Aktif" : "Nonaktif",
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: const [
                          Icon(Icons.inventory, color: Colors.orange, size: 32),
                          SizedBox(height: 8),
                          Text("Stock", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text("12 item", style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 🔹 Menu Grid
            const Text("Menu Utama", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: menuItems.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
              ),
              itemBuilder: (context, index) {
                final item = menuItems[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => item["page"]),
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(item["icon"], size: 36, color: Colors.blue),
                        const SizedBox(height: 8),
                        Text(item["title"], style: const TextStyle(fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),

      // 🔹 Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // aksi cepat misalnya tambah jadwal
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
