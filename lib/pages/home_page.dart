import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> menuItems = [
    {"title": "Keamanan", "icon": Icons.security},
    {"title": "Jadwal", "icon": Icons.schedule},
    {"title": "Stock", "icon": Icons.inventory},
    {"title": "Status Air", "icon": Icons.water_drop},
    {"title": "Laporan", "icon": Icons.description},
    {"title": "Pengaturan", "icon": Icons.settings},
  ];

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
              backgroundImage: AssetImage("assets/profile.png"), // foto profil
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
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: const [
                          Icon(Icons.lock, color: Colors.green, size: 32),
                          SizedBox(height: 8),
                          Text("Keamanan", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text("Aktif", style: TextStyle(color: Colors.grey)),
                        ],
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
                    // TODO: arahkan ke halaman sesuai menu
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
