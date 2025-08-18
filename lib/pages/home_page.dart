import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; 

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
  int stockJumlah = 12;

  @override
  Widget build(BuildContext context) {
    // 🔹 Tema warna futuristik
    const Color primaryColor = Color(0xFF0D1B2A);
    const Color secondaryColor = Color(0xFF1B263B);
    const Color accentColor = Color(0xFF415A77);
    const Color highlightColor = Color(0xFF778DA9);
    const Color textColor = Colors.white;

    return Scaffold(
      backgroundColor: primaryColor,
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
              children: [
                Text(
                  "Selamat Datang,",
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    color: highlightColor,
                  ),
                ),
                Text(
                  "Zidhan 👋",
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: "Logout",
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Ringkasan Status (Dashboard Cards)
            Row(
              children: [
                // Keamanan Card
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        keamananAktif = !keamananAktif; // toggle aktif/nonaktif
                      });
                    },
                    child: Card(
                      color: accentColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                            color: highlightColor.withOpacity(0.5), width: 1),
                      ),
                      elevation: 8,
                      shadowColor: highlightColor,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Icon(
                              keamananAktif ? Icons.lock : Icons.lock_open,
                              color: keamananAktif
                                  ? Colors.greenAccent
                                  : Colors.redAccent,
                              size: 32,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Keamanan",
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                            Text(
                              keamananAktif ? "Aktif" : "Nonaktif",
                              style: GoogleFonts.montserrat(
                                color: keamananAktif
                                    ? Colors.greenAccent
                                    : Colors.redAccent,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // Stock Card
                Expanded(
                  child: Card(
                    color: accentColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                          color: highlightColor.withOpacity(0.5), width: 1),
                    ),
                    elevation: 8,
                    shadowColor: highlightColor,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Icon(Icons.inventory,
                              color: Colors.orange, size: 32),
                          const SizedBox(height: 8),
                          Text(
                            "Stock",
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          Text(
                            "$stockJumlah item",
                            style: GoogleFonts.montserrat(
                              color: highlightColor,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 🔹 Menu Grid
            Text(
              "Menu Utama",
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
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
                      color: secondaryColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: highlightColor.withOpacity(0.3)),
                      boxShadow: [
                        BoxShadow(
                          color: highlightColor.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(item["icon"], size: 36, color: Colors.cyanAccent),
                        const SizedBox(height: 8),
                        Text(
                          item["title"],
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
